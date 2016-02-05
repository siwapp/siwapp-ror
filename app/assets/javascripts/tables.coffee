jQuery(document).ready ($) ->

  # Infinite Scroll for table based listings.
  # Add .js-iscroll to the <tbody> node that will contain the items.
  $('.js-iscroll').infinitescroll({
    navSelector: '.pagination'
    nextSelector: '.pagination .next_page'
    itemSelector: '.js-iscroll > tr'
    prefill: true
  })

  $(document)
    # Existing and future table rows with the data-href attribute act as links
    .on 'click', 'tr[data-href]', (e) ->
      e.preventDefault()
      window.document.location = $(this).data("href")

    # but avoid redirecting when clicking on a row-selection cell
    .on 'click', 'tr[data-href] > [data-role|="select"]', (e) ->
      e.stopPropagation()

    # manage row selection
    .on 'click', '[data-role|="select"] > :checkbox', (e) ->
      self = $(this)
      table = self.closest 'table'
      checked = self.is ':checked'

      if self.parent().data('role') == 'select-all'
        # All row selection checks has the same value as the select all
        table.find('[data-role="select"] > :checkbox').prop('checked', checked);
      else
        select_all = table.find('[data-role="select-all"] > :checkbox')
        if checked
          # select-all checkbox depends on the value of the other checkboxes
          table.find('[data-role="select"] > :checkbox').each () ->
            checked = checked and $(this).is ':checked'
        select_all.prop('checked', checked)
