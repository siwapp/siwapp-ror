module Util
  def get_currency
    Money::Currency.find Settings.currency
  end

  def currency_precision
    get_currency.exponent
  end
end
