class PaymentSerializer < ActiveModel::Serializer
  attributes :id, :notes, :date, :amount
  belongs_to :invoice
end
