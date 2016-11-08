class Common < ActiveRecord::Base
  include Util
  include MetaAttributes

  extend ModelCsv  # To export to csv file

  acts_as_paranoid

  # Relations
  belongs_to :customer
  belongs_to :series
  belongs_to :print_template, :class_name => 'Template', :foreign_key => 'print_template_id'
  belongs_to :email_template, :class_name => 'Template', :foreign_key => 'email_template_id'
  has_many :items, autosave: true, dependent: :destroy

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
    precision = get_currency.exponent.to_int
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
    taxes.each do |tax_name, tax_amount|
      taxes[tax_name] = tax_amount.round(precision)
    end
    taxes
  end

  # restore if soft deleted, along with its items
  def back_from_death
    restore! recursive: true
  end

  # Returns the invoice template if set, and the default otherwise
  def get_print_template
    if self.print_template
      return self.print_template
    end
    Template.find_by(print_default: true)
  end

  # Returns the invoice template if set, and the default otherwise
  def get_email_template
    if self.email_template
      return self.email_template
    end
    Template.find_by(email_default: true)
  end

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
    self.tax_amount = tax_amount.round(precision)
    self.net_amount = (base_amount - discount_amount).round(precision)
    self.gross_amount = net_amount + tax_amount
  end

  # make sure every soft-deleted item is really destroyed
  def purge_items
    items.only_deleted.delete_all
  end

  # returns a string with a csv format
  def self.csv(results)
    csv_string(results, self::CSV_FIELDS,
               results.meta_attributes_keys)
  end


protected

  # Declare scopes for search
  def self.ransackable_scopes(auth_object = nil)
    [:with_terms]
  end

end
