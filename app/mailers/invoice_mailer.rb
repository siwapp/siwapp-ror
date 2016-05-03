class InvoiceMailer < ApplicationMailer
  def email_invoice(invoice)
    @invoice = invoice
    html = render_to_string :inline => Template.find_by(default: true).template,
      :locals => {:invoice => @invoice, :settings => Settings}
    attachments["#{@invoice}.pdf"] = @invoice.pdf(html)
    mail(
      from: Settings.company_email,
      to: @invoice.email,
      subject: "Your invoice #{invoice}",
      body: Settings.email_to_send
    )
  end
end
