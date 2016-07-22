json.extract! template, :name
json.download_link rendered_template_url id: template.id, invoice_id: invoice.id, format: 'pdf'