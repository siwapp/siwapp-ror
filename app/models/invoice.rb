class Invoice < Common
  belongs_to :recurring_invoice

  def to_s
    "#{serie.value}#{number}"
  end
end
