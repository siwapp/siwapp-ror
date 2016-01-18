class Customer < ActiveRecord::Base
  has_many :invoices
  has_many :estimates
  has_many :recurring_invoices

  scope :with_terms, ->(terms) {
    return nil if terms.empty?
    where('name LIKE :terms OR email LIKE :terms OR identification LIKE :terms', terms: '%' + terms + '%')
  }

private

  def self.ransackable_scopes(auth_object = nil)
    [:with_terms]
  end
end
