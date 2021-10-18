class Common < ActiveRecord::Base
  include Wisper::Publisher
  include MetaAttributes

  extend ModelCsv  # To export to csv file

  # Behaviors
  acts_as_taggable
  acts_as_paranoid

  # Relations
  belongs_to :customer, optional: true
  belongs_to :series
  belongs_to :print_template,
    :class_name => 'Template',
    :foreign_key => 'print_template_id',
    optional: true
  belongs_to :email_template,
    :class_name => 'Template',
    :foreign_key => 'email_template_id',
    optional: true
  has_many :items, -> {order(id: :asc)}, autosave: true, dependent: :destroy
  accepts_nested_attributes_for :items,
    :reject_if => :all_blank,
    :allow_destroy => true

  # Validations
  validate :valid_customer_identification
  validates :series, presence: true
  # from https://emailregex.com/
  validates :email,
    format: {with: /\A([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,})\z/i,
             message: "Only valid emails"}, allow_blank: true
  validates :invoicing_address, format: { without: /<(.*)>.*?|<(.*) \/>/,
    message: "wrong format" }
  validates :shipping_address, format: { without: /<(.*)>.*?|<(.*) \/>/,
    message: "wrong format" }

  # Events
  after_save :purge_items
  after_save :update_amounts
  after_initialize :init

  # Search
  scope :with_terms, ->(terms) {
    return nil if terms.empty?
    joins(:items).where('name ILIKE :terms OR
           email ILIKE :terms OR
           identification ILIKE :terms OR
           description ILIKE :terms',
           terms: "%#{terms}%")
  }

  CSV_FIELDS = [
    "id", "customer_id", "name",
    "identification", "email",
    "invoicing_address", "shipping_address",
    "contact_person", "terms",
    "notes", "currency",
    "net_amount", "tax_amount", "gross_amount",
    "draft", "sent_by_email",
    "created_at", "updated_at",
    "print_template_id"
  ]

  def init
    begin
      # Set defaults
      unless self.id
        self.series ||= Series.default
        self.terms ||= Settings.legal_terms
        self.currency ||= Settings.currency
      end
    # Using scope.select also triggers this init method
    # so we have to deal with this exception
    rescue ActiveModel::MissingAttributeError
    end
  end

  # A hash with each tax amount rounded
  def taxes
    # Get taxes_hash for each item
    tax_hashes = items.each.map {|item| item.taxes_hash}
    # Sum and merge them
    taxes = tax_hashes.inject({}) do |memo, el|
      memo.merge(el){|k, old_v, new_v| old_v + new_v}
    end
    # Round of taxes is made over total of each tax
    taxes.each do |tax, amount|
      taxes[tax] = amount.round(currency_precision)
    end
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
    self.net_amount = items.reduce(0) {|sum, item| sum + item.net_amount}
    self.gross_amount = net_amount + tax_amount
  end

  def update_amounts
    set_amounts
    # Use update_columns to skip more callbacks
    self.update_columns(net_amount: self.net_amount, gross_amount: self.gross_amount)
  end

  # make sure every soft-deleted item is really destroyed
  def purge_items
    items.only_deleted.delete_all
  end

  # csv format
  def self.csv(results)
    csv_stream(results, self::CSV_FIELDS, results.meta_attributes_keys)
  end

  # Triggers an event via Wisper
  def trigger_event(event)
    broadcast(event, self)
  end

  def get_currency
    Money::Currency.find currency
  end

  def currency_precision
    get_currency.exponent
  end

protected

  # Declare scopes for search
  def self.ransackable_scopes(auth_object = nil)
    [:with_terms]
  end

private

  def valid_customer_identification
    unless name? or identification?
      errors.add :base, "Customer name or identification is required."
    end
  end

end
