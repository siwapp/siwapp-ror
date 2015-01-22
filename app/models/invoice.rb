class Invoice < Common
  belongs_to :recurring_invoice

  def to_s
    unless !serie
        "#{serie.value}#{number}"
    end
  end
end
