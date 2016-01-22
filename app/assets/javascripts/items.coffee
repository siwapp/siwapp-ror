jQuery(document).ready ($) ->
  $(".item-description").each () -> 
    jqThis = $(this)
    id_prefix = jqThis.attr('id').substring(0, jqThis.attr('id').lastIndexOf('_'))
    jqThis.autocomplete({
      source: '/invoices/autocomplete.json',
      select: (event, ui) ->
        $("##{id_prefix}_unitary_cost").val ui.item.unitary_cost
        $("##{id_prefix}_unitary_cost").trigger "change" # to trigger recalculations
    })
