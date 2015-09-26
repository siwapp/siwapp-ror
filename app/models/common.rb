class Common < ActiveRecord::Base
  # Relations
  belongs_to :customer
  belongs_to :series
  has_many :items, dependent: :delete_all
  accepts_nested_attributes_for :items, :reject_if => :all_blank, :allow_destroy => true
  validates :email,
    format: {with: /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i,
             message: "Only valid emails"}, allow_blank: true

  # Behaviors
  acts_as_taggable

  # Events
  before_save :set_amounts

  # Search
  scope :with_terms, ->(terms) {
    return nil if terms.empty?
    where('name LIKE :terms OR
           email LIKE :terms OR
           identification LIKE :terms',
           terms: terms + '%')
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
    items.each do |item|
      self.base_amount += item.base_amount
      self.discount_amount += item.discount_amount
      self.tax_amount += item.tax_amount
    end

    self.net_amount = base_amount - discount_amount
    self.gross_amount = net_amount + tax_amount
  end

end
