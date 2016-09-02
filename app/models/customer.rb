class Customer < ActiveRecord::Base
  include MetaAttributes
  
  acts_as_paranoid
  has_many :invoices
  has_many :estimates
  has_many :recurring_invoices

  before_destroy :check_invoices

  scope :with_terms, ->(terms) {
    return nil if terms.empty?
    where('name LIKE :terms OR email LIKE :terms OR identification LIKE :terms', terms: '%' + terms + '%')
  }

  def total
    invoices.where('draft = :draft', draft: false).sum :gross_amount || 0
  end

  def paid
    invoices.where('draft = :draft', draft: false).sum :paid_amount || 0
  end

  def due
    total - paid
  end

  def to_s
    if name?
      name
    elsif identification?
      identification
    elsif email?
      email
    else
      'Customer'
    end
  end

  def to_jbuilder
    Jbuilder.new do |json|
      json.(self, *(attribute_names - ["name_slug", "deleted_at"]))
    end
  end


private

  def check_invoices
    if self.total > self.paid
      errors[:base] << "This customer can't be deleted because it has unpaid invoices"
      return false
    end
    true
  end

  def self.ransackable_scopes(auth_object = nil)
    [:with_terms]
  end
end
