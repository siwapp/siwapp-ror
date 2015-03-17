# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery ->
  if $('#infinite-scrolling').size() > 0
    $(window).on 'scroll', ->
      more_posts_url = $('.pagination .next_page').attr('href')
      window.more_posts_url = more_posts_url
      if more_posts_url && $(window).scrollTop() > $(document).height() - $(window).height() - 60
          $('.pagination').html('<img src="/assets/ajax-loader.gif" alt="Loading..." title="Loading..." />')
          $.getScript more_posts_url
        return
      return

$ ->
  $('a.calculate-amounts').on 'click', ->
    # obtain form fields
    fields = $('form[data-model=invoice]').serialize()
    # add fields to query params
    href = $(this).attr('href') + '?' + fields
    $(this).attr('href', href)

$ ->
  $('a[data-remote]').on 'ajax:success', (e, data, status, xhr) ->
    alert(data.gross_amount)
