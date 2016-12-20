jQuery(document).ready ($) ->
  $(document).on 'change', '[data-role="select-default"]', (e) ->
    $(this).closest('form').submit()
