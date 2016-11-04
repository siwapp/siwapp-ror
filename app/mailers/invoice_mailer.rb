class InvoiceMailer < ApplicationMailer
  add_template_helper TemplatesHelper
  add_template_helper ApplicationHelper
  
  include Util
  helper_method :get_currency
  
  def email_invoice(invoice)
    @invoice = invoice

    # Getting email templates
    if @invoice.email_template
      email_template = @invoice.email_template
    else
      email_template = Template.find_by(email_default: true)
    end
    # E-mail parts
    body_template = email_template.template
    subject_template = email_template.subject

    # Getting pdf templates
    if @invoice.print_template
      print_template = @invoice.print_template.template
    else
      print_template = Template.find_by(print_default: true).template
    end
    # Rendering the and composing mail content
    pdf_html = render_to_string :inline => print_template,
      :locals => {:invoice => @invoice, :settings => Settings}
    email_subject = render_to_string :inline => subject_template,
      :locals => {:invoice => @invoice, :settings => Settings}
    email_body = render_to_string :inline => body_template,
      :locals => {:invoice => @invoice, :settings => Settings}
    attachments["#{@invoice}.pdf"] = @invoice.pdf(pdf_html)
    
    # Sending the email
    mail(
      from: Settings.company_email,
      # Just for testing
      to: "kike@doofinder.com,enrique@doofinder.com", #@invoice.email,
      subject: email_subject,
      body: email_body
    ) do |format|
      format.html {email_body}
    end
  end
end
