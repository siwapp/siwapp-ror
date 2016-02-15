class InvoiceMailer < ApplicationMailer
  def email_invoice(invoice)
    @invoice = invoice
    mail(
      to: @invoice.email,
      subject: "Your invoice #{invoice}"
    )
  end
end
