# Function to recalculate amounts
set_amounts = ->
  url = Routes.commons_amounts_path() + '?' + $('form[data-model=invoice]').serialize()
  $.get url, ->
    return

# Works with Turbolinks thanks to:
# - http://github.com/kossnocorp/jquery.turbolinks
# - https://github.com/rails/turbolinks#jqueryturbolinks
$(document).ready ->
  console.log("Commons Javascript")

  $('.js-iscroll').infinitescroll({
    navSelector: '.pagination',
    nextSelector: '.pagination .next_page',
    itemSelector: '.js-iscroll > tr',
    prefill: true
  });

  # On changes on the inputs, recalculates amounts
  $('#items').on 'change', (e)->
    # If the change is on description do nothing
    if $(e.target).prop('tagName') == 'TEXTAREA'
      return
    set_amounts()

  $('.remove_fields').click ->
    setTimeout set_amounts, 500
