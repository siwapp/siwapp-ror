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

  if $('#infinite-scrolling').length > 0
    $(window).on 'scroll', ->
      more_posts_url = $('.pagination .next_page').attr('href')
      window.more_posts_url = more_posts_url
      if more_posts_url && $(window).scrollTop() > $(document).height() - $(window).height() - 60
          $('.pagination').html('<img src="/assets/ajax-loader.gif" alt="Loading..." title="Loading..." />')
          $.getScript more_posts_url
        return
      return

  # On changes on the inputs, recalculates amounts
  $('#items').on 'change', (e)->
    # If the change is on description do nothing
    if $(e.target).prop('tagName') == 'TEXTAREA'
      return
    set_amounts()

  $('.remove_fields').click ->
    setTimeout set_amounts, 500
