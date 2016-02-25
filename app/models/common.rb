class Common < ActiveRecord::Base
  # Relations
  belongs_to :customer
  belongs_to :series
  has_many :items, dependent: :delete_all
  accepts_nested_attributes_for :items, :reject_if => :all_blank, :allow_destroy => true
  validates :email,
    format: {with: /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i,
             message: "Only valid emails"}, allow_blank: true
  attr_accessor :taxes  # to store totals for each tax
  attr_accessor :original_amounts # to store the originals amounts as obtained from db

  # Behaviors
  acts_as_taggable

  # Events
  before_save :set_amounts

  after_initialize do
    assign_originals
    set_amounts
  end


  # Search
  scope :with_terms, ->(terms) {
    return nil if terms.empty?
    where('name LIKE :terms OR
           email LIKE :terms OR
           identification LIKE :terms',
           terms: '%' + terms + '%')
  }

protected

  # Declare scopes for search
  def self.ransackable_scopes(auth_object = nil)
    [:with_terms]
  end

public

  def set_amounts
    self.base_amount = 0
    self.discount_amount = 0
    self.tax_amount = 0
    self.taxes = {}
    items.each do |item|
      self.base_amount += item.base_amount
      self.discount_amount += item.discount_amount
      item.taxes.each do |tax|  # totals for each type of tax
        begin
          self.taxes[tax.name] += item.net_amount * tax.value / 100.0
        rescue NoMethodError
          self.taxes[tax.name] = item.net_amount * tax.value / 100.0
        end
      end
      self.tax_amount += item.tax_amount
    end

    self.net_amount = base_amount - discount_amount
    self.gross_amount = net_amount + tax_amount
    check_if_changed # manually mark amount attrs as changed if needed
  end

private

  # to know if amount attrs have changed later on the instance's lifecycle
  def assign_originals
    self.original_amounts = {}
    [:base_amount, :discount_amount, :tax_amount, :net_amount, :gross_amount].each do |aname|
      self.original_amounts[aname] = send aname
    end
  end

  def check_if_changed
    [:base_amount, :discount_amount, :tax_amount, :net_amount, :gross_amount].each do |aname|
      if original_amounts[aname] != send(aname)
        send "#{aname}_will_change!"
      end
    end
  end

end
