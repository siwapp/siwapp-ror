class InvoiceMailer < ApplicationMailer
  add_template_helper TemplatesHelper
  add_template_helper ApplicationHelper
  # TODO(@ecoslado) There's some repeated code. get_currency is also defined in ApplicationController
  helper_method :get_currency


  def get_currency
    return Money::Currency.find Settings.currency
  end
  
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
