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
#= require jquery_ujs
#= require jquery-ui/widgets/autocomplete
#= require waypoints/jquery.waypoints
#= require waypoints/shortcuts/infinite
#= require fastclick
#= require d3
#= require c3
#= require autosize
#= require behave
#= require select2
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
# Custom
#= require bothinfinite


jQuery(document).ready ($) ->
  new FastClick(document.body)

  $('.code-editor').each () ->
    editor = new Behave({textarea: this})

  autosize $('textarea.autosize')
