module ApplicationHelper
  include StiHelper


  def title(*parts)
    unless parts.empty?
      content_for :title do
        (parts << "Siwapp").join(" - ")
      end
    end
  end

  # To put class=active into the menu links
  def active_link(link)
    link.split(',').each do |value|
      if value.strip == params[:controller]
        "active"
      end
    end
    ""
  end

  def display_money(amount, currency=Settings.currency)
    currency = Money::Currency.find currency
    format = currency.symbol_first? ? "%u %n" : "%n %u"
    number_to_currency amount, precision: currency.exponent, unit: currency.symbol,
    separator: currency.separator, delimiter: currency.delimiter, format: format,
    negative_format: "(#{format})"
  end

  def set_redirect_address(address, type)
    session[:redirect_to] = {address: address, type: type}
  end

  def redirect_address(type)
    if session[:redirect_to] && session[:redirect_to]["type"] == type
      session[:redirect_to]["address"]
    else
      sti_path(type)
    end
  end

  def i18n_url_for(options)
    if options[:locale] == I18n.default_locale
      options[:locale] = nil
    end
    url_for(options)
  end

end
