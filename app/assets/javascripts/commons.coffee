# Function to recalculate amounts
# Receives a controller name as string, and a form object to serialize, and
# retrieves the amounts from the server.
set_amounts = (controller_name, form) ->
  url = Routes[controller_name + '_amounts_path']() + '?' + form.serialize()
  $.get url, ->
    return

# Works with Turbolinks thanks to:
# - http://github.com/kossnocorp/jquery.turbolinks
# - https://github.com/rails/turbolinks#jqueryturbolinks
jQuery(document).ready ($) ->

  # Infinite Scroll for table based listings.
  # Add .js-iscroll to the <tbody> node that will contain the items.
  $('.js-iscroll').infinitescroll({
    navSelector: '.pagination'
    nextSelector: '.pagination .next_page'
    itemSelector: '.js-iscroll > tr'
    prefill: true
  })

  # Find forms that behave like an invoice
  # Those forms have a data-controller attribute that contains the current
  # controller name and are matched also by a .js-invoice-like class.
  $('form.js-invoice-like[data-controller]').each ->
    # TODO(@carlos): If the form doesn't have the class and the data- attribute
    # it won't match. Maybe it will be better to be less restrictive and throw
    # an error to warn the developer.
    form = $(this)
    controller_name = form.data('controller')

    # Find sections that change the amounts of the invoice-like form
    form.find('[data-changes="amount"]')
      # When an item changes, update form amounts
      .on 'change', '.js-item', (e) ->
        item = $(e.target)
        if item.prop 'tagName' == 'TEXTAREA'
          return
        set_amounts(controller_name, form)
      # When an item is removed, update form amounts
      .on 'cocoon:after-remove', (e, item) ->
        set_amounts(controller_name, form)

    # Set the autocomplete for customer selection
    model = form.data('model')
    $("##{model}_customer_name").autocomplete {
      source: '/customers/autocomplete.json',
      select: (event, ui) ->
        # Once the customer is selected autofill fields:
        $("##{model}_customer_id").val ui.item.id
        $("##{model}_customer_identification").val ui.item.identification
        $("##{model}_customer_email").val ui.item.email
        $("##{model}_contact_person").val ui.item.contact_person
        $("##{model}_invoicing_address").val ui.item.invoicing_address
        $("##{model}_shipping_address").val ui.item.shipping_address
    }
