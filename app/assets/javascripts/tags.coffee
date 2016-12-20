jQuery(document).ready ($) ->
  $('[data-role="tagging"]').select2
    tags: true,
    tokenSeparators: [',']
    closeOnSelect: false
