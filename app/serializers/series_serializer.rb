class SeriesSerializer < ActiveModel::Serializer
  attributes :name, :value, :enabled, :first_number
end
