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
#= require jquery
#= require jquery.turbolinks
#= require jquery_ujs
#= require bootstrap-sprockets
#= require_tree
#= require cocoon
#= require js-routes
#= require infinite-scroll
#= require typeahead
#= require bootstrap-tagsinput
#= require turbolinks

# All table rows with the clickable-row class act as links:
window.clickable_rows = ->
  $(".clickable-row").click ->
    window.document.location = $(this).data("href")

jQuery(document).ready ($) ->
  clickable_rows()
