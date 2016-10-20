require 'csv'

module ModelCsv
  # Generates a csv in a string
  def csv_string(results, fields, meta_attributes_keys)
    csv_string = CSV.generate do |csv|
      # put the header of the csv
      csv << fields + meta_attributes_keys
      # iterate over results
      results.each do |i|
        meta_attributes_values = meta_attributes_keys.map do |key|
          i.meta[key]
        end
        csv <<
          fields.map {|field| i[field]} + meta_attributes_values
      end
    end
  end
end
