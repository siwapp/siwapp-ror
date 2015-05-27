class Common < ActiveRecord::Base
  # Relations
  belongs_to :customer
  belongs_to :series
  has_many :items, dependent: :delete_all
  accepts_nested_attributes_for :items, :reject_if => :all_blank, :allow_destroy => true

  # Behaviors
  acts_as_taggable

  # Events
  before_save :set_amounts

  # Search
  scope :terms, lambda {|query|
    return nil  if query.blank?

    # Split terms to search for
    terms = query.downcase.split(/\s+/)
    terms = terms.map { |e|
      (e.gsub('*', '%') + '%').gsub(/%+/, '%')
    }

    num_or_conds = 2

    where(
      terms.map {|term|
        "(LOWER(commons.customer_name) LIKE ? OR LOWER(commons.customer_email) LIKE ?)"
      }.join(' AND '),
      *terms.map {|e| [e] * num_or_conds }.flatten
    )
  }

  # Filter by series
  scope :with_series_id, lambda { |series_ids|
    where(series_id: [*series_ids])
  }

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
