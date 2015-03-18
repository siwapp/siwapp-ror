# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  if $('#infinite-scrolling').size() > 0
    $(window).on 'scroll', ->
      more_posts_url = $('.pagination .next_page').attr('href')
      window.more_posts_url = more_posts_url
      if more_posts_url && $(window).scrollTop() > $(document).height() - $(window).height() - 60
          $('.pagination').html('<img src="/assets/ajax-loader.gif" alt="Loading..." title="Loading..." />')
          $.getScript more_posts_url
        return
      return

  $('a.calculate-amounts')
    .on 'ajax:beforeSend', (e, xhr, settings) ->
      # Add all the form data to the url
      settings.url += '?' + $('form[data-model=invoice]').serialize()
      return

# We have to use this because of turbolinks.
# See http://stackoverflow.com/questions/18770517/rails-4-how-to-use-document-ready-with-turbo-links
$(document).ready(ready)
$(document).on('page:load', ready)

