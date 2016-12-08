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

  # A hash with each tax amount rounded
  def taxes
    # Get taxes_hash for each item
    tax_hashes = items.each.map {|item| item.taxes_hash}
    # Sum and merge them
    taxes = tax_hashes.inject({}) {|memo, el| memo.merge(el){|k, old_v, new_v| old_v + new_v}}
    # Round of taxes is made over total of each tax
    taxes.each {|tax, amount| taxes[tax] = amount.round(currency_precision)}
  end

  def have_items_discount?
    items.each do |item|
      if item.discount > 0
        return true
      end
    end
    false
  end

  # Total taxes amount added up
  def tax_amount
    self.taxes.values.reduce(0, :+)
  end

  # restore if soft deleted, along with its items
  def back_from_death
    restore! recursive: true
  end

  # Returns the invoice template if set, and the default otherwise
  def get_print_template
    return self.print_template ||
      Template.find_by(print_default: true) ||
      Template.first
  end

  # Returns the invoice template if set, and the default otherwise
  def get_email_template
    return self.email_template ||
      Template.find_by(email_default: true) ||
      Template.first
  end

  def set_amounts
    self.net_amount =
        items.reduce(0) {|sum, item| sum + item.net_amount}
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
