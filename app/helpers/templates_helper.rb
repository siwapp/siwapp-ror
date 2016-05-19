module TemplatesHelper
  def format_address(address)
    address.gsub("\r\n", "<br>").gsub("\n", "<br>").html_safe
  end
end
