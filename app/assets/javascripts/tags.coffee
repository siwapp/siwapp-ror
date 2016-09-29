jQuery(document).ready ($) ->
  tagging_fields = $ '[data-role="tagging"]'
  tagging_fields.select2
    tags: true,
    tokenSeparators: [',']
