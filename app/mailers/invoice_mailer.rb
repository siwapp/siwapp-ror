class InvoiceMailer < ApplicationMailer
  add_template_helper TemplatesHelper
  add_template_helper ApplicationHelper
  
  include Util
  helper_method :get_currency
  
  def email_invoice(invoice)
    @invoice = invoice

    if @invoice.email_template
      email_template = @invoice.email_template.template
    else
      email_template = Template.find_by(email_default: true).template
    end

    if @invoice.print_template
      print_template = @invoice.print_template.template
    else
      print_template = Template.find_by(print_default: true).template
    end
    
    pdf_html = render_to_string :inline => print_template,
      :locals => {:invoice => @invoice, :settings => Settings}
    email_body = render_to_string :inline => email_template,
      :locals => {:invoice => @invoice, :settings => Settings}
    attachments["#{@invoice}.pdf"] = @invoice.pdf(pdf_html)
    mail(
      from: Settings.company_email,
      # Just for testing
      to: "kike@doofinder.com", #@invoice.email,
      subject: Settings.email_subject,
      body: email_body
    ) do |format|
      format.html {email_body}
    end
  end
end
