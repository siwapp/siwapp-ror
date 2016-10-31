class PaymentSerializer < ActiveModel::Serializer
  attributes :id, :notes, :date, :amount
end
