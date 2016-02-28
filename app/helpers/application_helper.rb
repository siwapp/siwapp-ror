module ApplicationHelper
  def title(*parts)
    unless parts.empty?
      content_for :title do
        (parts << "Siwapp").join(" - ")
      end
    end
  end

  # To put class=active into the menu links
  def active_link(link)
    (link == params[:controller]) ? "active" : ""
  end

  def display_money(amount)
    currency_code = Rails.cache.fetch('currency', expires_in: 1.hour) do
      Property.find_or_initialize_by(key: :currency).value || :eur
    end

    currency = Money::Currency.find currency_code
    format = currency.symbol_first? ? "%u%n" : "%n%u"
    negative_format = "(#{format})"
    number_to_currency amount, precision: currency.exponent.to_int, unit: currency.symbol,
    separator: currency.separator, delimiter: currency.delimiter, format: format,
    negative_format: negative_format
  end

end
