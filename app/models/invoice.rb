class Invoice < Common
  belongs_to :recurring_invoice

  def to_s
    if serie
      "#{serie.value}#{number}"
    else
      "XXX-#{number}"
    end
  end
end
