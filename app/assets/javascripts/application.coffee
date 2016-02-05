# This is a manifest file that'll be compiled into application.js, which will include all the files
# listed below.
#
# Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
# or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
#
# It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
# compiled file.
#
# Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
# about supported directives.
#
# jQuery & Utils
#
#= require jquery2
#= require jquery.turbolinks
#= require jquery_ujs
#= require jquery-ui/autocomplete
#= require jquery.infinitescroll
#= require fastclick
#
# Bootstrap 4
#
#= require tether
#= require bootstrap
#
#= require_tree .
#= require cocoon
#= require js-routes
#
#= require turbolinks


jQuery(document).ready ($) ->
  new FastClick(document.body)

  # All existing and future table rows with the data-href attribute act as links
  $(document).on 'click', 'tr[data-href]', (e) ->
    e.preventDefault()
    window.document.location = $(this).data("href")

  # Avoid redirecting when clicking on checkbox cell
  $(document).on 'click', 'td.checks', (e) ->
    $(':checkbox[name=check_all]').prop('checked', false)
    e.stopPropagation()

  $(document).on 'click', ':checkbox[name=check_all]', (e) ->
    checked = $(this).is(':checked')
    $('td.checks input:checkbox').prop('checked', checked)

  # Bottom buttons to save forms:
  $(document).on 'click', '.form-save', (e) ->
    e.preventDefault()
    $('form').submit()

