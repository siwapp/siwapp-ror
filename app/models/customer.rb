class Customer < ActiveRecord::Base
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
