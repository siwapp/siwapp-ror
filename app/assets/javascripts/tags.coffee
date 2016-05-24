jQuery(document).ready ($) ->

  # 'a, b,  c, d,e' => ['a', 'b', 'c', 'd', 'e']
  split_tags = (value) ->
    value.split /,\s*/

  # 'a, b, c, d, e' => 'e'
  last_tag = (value) ->
    split_tags(value).pop()

  # Configure inputs for tagging
  $( 'textarea[data-role="tagging"]' )
    .on 'keydown', (e) ->
      # Don't navigate away from the field on tab when selecting an item
      if e.keyCode is $.ui.keyCode.TAB and $(this).autocomplete('instance').menu.active
        e.preventDefault()
    .autocomplete {
      minLength: 0,
      source: (request, response) ->
        # Delegate back to autocomplete, but extract the last term
        response( $.ui.autocomplete.filter( window.availableTags || {}, last_tag(request.term) ) )
      ,
      focus: ->
        # Prevent value inserted on focus
        return false
      ,
      select: (e, ui) ->
        terms = split_tags this.value
        # Remove the current input
        terms.pop()
        # Add the selected item
        terms.push ui.item.value
        # Add placeholder to get the comma-and-space at the end
        terms.push ''
        this.value = terms.join ', '
        return false
    }
