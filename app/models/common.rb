class Common < ActiveRecord::Base
  include Util
  acts_as_paranoid
  # Relations
  belongs_to :customer
  belongs_to :series
  has_many :items, dependent: :destroy

  accepts_nested_attributes_for :items, :reject_if => :all_blank, :allow_destroy => true
  validates :email,
    format: {with: /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i,
             message: "Only valid emails"}, allow_blank: true

  # Behaviors
  acts_as_taggable

  # Events
  before_save :set_amounts
  after_update :purge_items

  # Search
  scope :with_terms, ->(terms) {
    return nil if terms.empty?
    where('name LIKE :terms OR
           email LIKE :terms OR
           identification LIKE :terms',
           terms: '%' + terms + '%')
  }

  def taxes
    taxes = {}
    items.each do |item|
      item.taxes.each do |tax|
        begin
          taxes[tax.name] += item.net_amount * tax.value / 100.0
        rescue NoMethodError
          taxes[tax.name] = item.net_amount * tax.value / 100.0
        end
      end
    end
    taxes
  end

  # restore if soft deleted, along with its items
  def back_from_death
    restore! recursive: true
  end


  def get_meta(key)
    if self.meta_attributes?
      attributes = ActiveSupport::JSON.decode(self.meta_attributes)
      attributes[key]
    end
  end

  def set_meta(key, value)
    if self.meta_attributes?
      attributes = ActiveSupport::JSON.decode(self.meta_attributes)
    else
      attributes = {}
    end
    attributes[key] = value
    attributes = ActiveSupport::JSON.encode(attributes)
    self.meta_attributes = attributes
    self.save
  end

  def set_meta_multi(attr_hash)
    attributes = {}
    attr_hash.each do |key, value|
      attributes[key] = value
    end
    self.meta_attributes = ActiveSupport::JSON.encode(attributes)
    self.save  
  end

  def meta()
    if self.meta_attributes?
      return ActiveSupport::JSON.decode(self.meta_attributes)
    else
      return {}
    end
  end

protected

  # Declare scopes for search
  def self.ransackable_scopes(auth_object = nil)
    [:with_terms]
  end

public

  def set_amounts
    precision = get_currency.exponent.to_int
    self.base_amount = 0
    self.discount_amount = 0
    self.tax_amount = 0
    items.each do |item|
      self.base_amount += item.base_amount
      self.discount_amount += item.discount_amount
      self.tax_amount += item.tax_amount
    end

    self.net_amount = base_amount - discount_amount
    self.gross_amount = (net_amount + tax_amount).round(precision)

  end

  # make sure every soft-deleted item is really destroyed
  def purge_items
    items.only_deleted.delete_all
  end

end
