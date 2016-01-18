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
#= require jquery2
#= require jquery.turbolinks
#= require jquery_ujs
#= require jquery-ui/autocomplete
# This tether.min is required by bootstrap4 and should be before it
#= require tether.min
#= require bootstrap-sprockets
#= require_tree
#= require cocoon
#= require js-routes
#= require jquery.infinitescroll
#= require turbolinks


jQuery(document).ready ($) ->
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
