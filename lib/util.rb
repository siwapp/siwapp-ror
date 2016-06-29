module Util
  def get_currency
    return Money::Currency.find Settings.currency
  end
end