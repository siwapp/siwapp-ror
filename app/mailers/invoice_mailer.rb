class InvoiceMailer < ApplicationMailer
  add_template_helper TemplatesHelper
  add_template_helper ApplicationHelper
  
  include Util
  helper_method :get_currency
  
  def email_invoice(invoice)
    @invoice = invoice

    if @invoice.email_template
      template = @invoice.email_template.template
    else
      template = Template.find_by(email_default: true).template
    end
    html = render_to_string :inline => template,

      :locals => {:invoice => @invoice, :settings => Settings}
    attachments["#{@invoice}.pdf"] = @invoice.pdf(html)
    mail(
      from: Settings.company_email,
      # Just for testing
      to: "kike@doofinder.com", #@invoice.email,
      subject: Settings.email_subject,
      body: html
    ) do |format|
      format.html {html}
    end
  end
end
