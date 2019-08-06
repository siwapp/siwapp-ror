# Function to recalculate amounts
# Receives a controller name as string, and a form object to serialize, and
# retrieves the amounts from the server.
set_amounts = (controller_name, form) ->
  url = Routes[controller_name + '_amounts_path']() + '?' + form.serialize()
  $.get url, ->
    return

# Function to get amounts json and do anything with them via callback
# Receives a controller name as string, and a form object to serialize
# retrieves amounts in a json
get_amounts = (controller_name, form, callback) ->
  url = Routes[controller_name + '_amounts_path']() + '?' + form.serialize()
  $.ajax url: url, dataType: 'json', success: (data) ->
    return callback data

get_item_amount = (quantity, unitary_cost, discount, callback) ->
  url = Routes['items_amount_path']() + \
    "?quantity=#{quantity}&unitary_cost=#{unitary_cost}&discount=#{discount}"
  $.ajax url: url, dataType: 'json', success: (data) ->
    return callback data

# Gets a json with the default taxes
get_defaults_taxes = (callback) ->
  url = Routes['taxes_get_defaults_path']()
  $.ajax url: url, dataType: 'json', success: (data) ->
    return callback data

# Retrieves the common part of the id of all fields in a cocoon formset row
get_id_prefix = (input_field) ->
  id_prefix = input_field.attr('id')
  id_prefix = id_prefix.substring(0, id_prefix.lastIndexOf('_'))
  id_prefix

# Function to initialize autocomplete behavior on invoice-like items
# on load and when a new item is inserted.
init_invoice_item_autocomplete = (input_field) ->
  id_prefix = get_id_prefix input_field
  input_field.autocomplete source: '/invoices/autocomplete.json', select: (event, ui) ->
    $("##{id_prefix}_unitary_cost").val ui.item.unitary_cost
    $("##{id_prefix}_unitary_cost").trigger "change" # to trigger recalculations


# Function to deactivate autocomplete behavior on invoice-like items
# when they are removed.
destroy_invoice_item_autocomplete = (input_field) ->
  if input_field.data 'autocomplete'
    input_field.autocomplete 'destroy'
    input_field.removeData 'autocomplete'


# Works with Turbolinks thanks to:
# - http://github.com/kossnocorp/jquery.turbolinks
# - https://github.com/rails/turbolinks#jqueryturbolinks
jQuery(document).ready ($) ->

  #
  # DIY Nested Forms: necessary when no model relation
  #

  # Find each "Add X-Thing" button and get the item's template from the last
  # supposed-to-be-empty item. Configure the event handler so, when clicked,
  # the button inserts a copy of the template node into the proper container.
  $('[data-role="add-item"]').each () ->
    self = $(this)

    insertionNode = self.data("insertion-node")
    eventData =
      insertionNode: insertionNode
      template: $(insertionNode).find('[data-role="new-item"]').last().clone()

    self.on "click", eventData, (e) ->
      e.preventDefault()
      e.data.template.clone().appendTo(e.data.insertionNode)

  # Use event delegation to configure X-Thing items so they can be removed when
  # the proper button is pressed.
  $('body').on "click", '[data-role="remove-item"]', (e) ->
    e.preventDefault()
    self = $(this)
    self.closest(".#{self.data("wrapper-class")}").remove()

  #
  # Invoice-like Forms
  #

  form = $('form[data-role="invoice"]')
  controller_name = form.data('controller')  # REQUIRED!!!

  # DOM caching
  invoice_series = $('#invoice_series_id')
  invoice_number = $('#invoice_number')

  if form.data('new') is false
    # If the form is for editing an existing invoice

    invoice_series.on 'change', (e) ->
      if parseInt(invoice_series.val(), 10) ==
          parseInt(invoice_series.data('series_id_was'), 10)
        invoice_number.val(invoice_number.data 'number_was')
        invoice_number.parent().show()
      else
        invoice_number.val ''
        invoice_number.parent().hide()

  autosize form.find('textarea')

  # Find sections that change the amounts of the invoice-like form
  form.find('[data-changes="amount"]')
    # When an item changes, update form amounts
    .on 'change input', '.js-item', (e) ->
      item = $(e.target)
      if item.prop('tagName') == 'TEXTAREA'
        return
      # Set the net amount of the item
      item_row = item.parents('.js-item')
      quantity = item_row.find('[data-role="quantity"]').val()
      price = item_row.find('[data-role="unitary-cost"]').val()
      discount = item_row.find('[data-role="discount"]').val()
      get_item_amount quantity, price, discount, (data) ->
        net_amount = data.amount
        item_row.find('[data-role="net-amount"]').val(net_amount)
        item_row.find('.js-net-amount').html(net_amount)

      # Set total amounts of invoice
      set_amounts(controller_name, form)
    # When an item is removed, update form amounts
    .on 'cocoon:after-remove', (e, item) ->
      set_amounts(controller_name, form)

  # Find invoice items and init autocomplete
  form.find('[data-role="item-description"]').each () ->
    init_invoice_item_autocomplete $(this)

  # Set defaults when adding something dynamic to the form with cocoon
  form.on 'cocoon:after-insert', (e, item) ->
    if item.hasClass 'js-payment'
      # default amount is what's unpaid
      amount_item = item.find 'input[name*=amount]'
      get_amounts controller_name, form, (data) ->
        amount = data.gross_amount - data.paid_amount
        amount = if amount > 0 then amount else 0
        amount_item.val Math.round(amount*10**data.precision)/10**data.precision
        return
      # default date is today
      date_item = item.find 'input[name*=date]'
      date_item.val (new Date).toISOString().substr 0, 10
    else if item.hasClass 'js-item'
      init_invoice_item_autocomplete item.find('[data-role="item-description"]')
      tax_selector = item.find('[data-role="taxes-selector"]')
      tax_selector.trigger('update')
      # Set default tax values
      get_defaults_taxes (data) ->
        new_val = (tax.id for tax in data.data)
        tax_selector.val(new_val).trigger('change.select2')
      autosize item.find('textarea')

  # UX for taxes-selector labels
  form.on 'click', '[data-role="taxes-selector-label"]', (e) ->
    $(this).closest('.js-item').find('.select2-search__field').click()

  # Execute actions when something dynamic is removed from the form
  # with cocoon
  form.on 'cocoon:before-remove', (e, item) ->
    if item.hasClass 'js-item'
      destroy_invoice_item_autocomplete item

  # Set the autocomplete for customer selection
  model = form.data('model')
  $("##{model}_name").autocomplete {
    source: '/customers/autocomplete.json',
    select: (event, ui) ->
      # Once the customer is selected autofill fields:
      $("##{model}_customer_id").val ui.item.id
      $("##{model}_identification").val ui.item.identification
      $("##{model}_email").val ui.item.email
      $("##{model}_contact_person").val ui.item.contact_person
      $("##{model}_invoicing_address").val ui.item.invoicing_address
      $("##{model}_shipping_address").val ui.item.shipping_address
      autosize.update $('textarea.autosize')
  }

  # Configure Tax Selector behavior
  $('[data-role="taxes-selector"]').select2()
  $('#js-items-table').on 'cocoon:after-insert', (e, insertedItem) ->
    $(insertedItem).find('[data-role="taxes-selector"]').select2()

  form
    .on 'update', '[data-role="taxes-selector"]', () ->
      checked_taxes = $(this).find(':checked')
      label = []
      checked_taxes.each () ->
        label.push $(this).closest('.checkbox').text().trim()
      total = if label.length > 1 then ('(' + label.length + ')') else ''
      label = if label.length > 0 then label.join(', ') else 'None'
      $(this).find('[data-role="label"]').html(label)
      $(this).find('[data-role="total"]').html(total)
    .on 'change', '[data-role="taxes-selector"] :checkbox', (e) ->
      $(this).closest('[data-role="taxes-selector"]').trigger('update')
    .find('[data-role="taxes-selector"]').trigger('update')

  #
  # Action Buttons
  #

  # Submit Search Form to download CSV files
  $(document).on 'click', '[data-role="csv-form"]', (e) ->
    e.preventDefault()
    old_action = $('#js-search-form').attr('action')
    # To download csv you must split by the querystring
    new_action = old_action.split("?")[0]
    $('#js-search-form').attr('action', "#{new_action}.csv")

    $('#js-search-form').submit()
    # back to normal action
    $('#js-search-form').attr('action', "#{old_action}")

  # Submit Form
  $(document).on 'click', '[data-role="submit-form"]', (e) ->
    e.preventDefault()
    if $(this).data('action')  # if we have data-action on button, set the action
      $('#bulk_action').val($(this).data('action'))
    if $(this).data('activateFlag')
      flagName = $(this).data('activateFlag')
      $("input[name='#{flagName}']").val('true')
    $($(this).data('target')).submit()

  #
  # Listings
  #

  # Section Header/Info collapse
  sectionInfo = $('#js-section-info')
  sectionInfoButton = $('#js-section-info-button')

  sectionInfo.on 'show.bs.collapse', (e) ->
    sectionInfoButton.addClass('toggled')

  sectionInfo.on 'hide.bs.collapse', (e) ->
    sectionInfoButton.removeClass('toggled')

  #
  # Search
  #

  $('[data-role="select-autocomplete"]').select2
    theme: "bs4"
