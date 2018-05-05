require 'csv'

module ModelCsv

  # Enumerator that generates csv lines
  def csv_stream(results, fields, meta_attributes_keys)
    Enumerator.new do |y|
      # header line
      y << CSV.generate_line(fields + meta_attributes_keys)
      # items
      results.each do |i|
        meta_attributes_values = meta_attributes_keys.map {|key| i.meta[key]}
        y << CSV.generate_line(
          fields.map {|field| i.send(field)} + meta_attributes_values
        )
      end
    end
  end

end
