class InvoiceMailer < ApplicationMailer
  add_template_helper TemplatesHelper
  add_template_helper ApplicationHelper
  
  include Util
  helper_method :get_currency
  
  def email_invoice(invoice)
    @invoice = invoice
    html = render_to_string :inline => Template.find_by(default: true).template,
      :locals => {:invoice => @invoice, :settings => Settings}
    attachments["#{@invoice}.pdf"] = @invoice.pdf(html)
    mail(
      from: Settings.company_email,
      to: @invoice.email,
      subject: Settings.email_subject,
      body: Settings.email_body
    )
  end
end
