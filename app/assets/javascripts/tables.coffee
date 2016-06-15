# try to make it custom

class BothInfinite extends Waypoint.Infinite
  constructor: (options) ->
    super(options)
    @$less = jQuery @options.less

    if @$less.length
      @lessOptions = jQuery.extend({}, @options, {offset: 0})
      @setupLessHandler()
      @lessWaypoint = new Waypoint(@lessOptions)

  destroy: () ->
    super()
    if @lessWaypoint
      @lessWaypoint.destroy()

  setupLessHandler: () ->

    @lessOptions.handler = jQuery.proxy(
      (direction) ->
        @$container.addClass @lessOptions.loadingClass
        if direction == 'down'
          return
        @destroy()
        $.get(@$less.attr('href'), $.proxy(
          (data) ->
            $data = $($.parseHTML data)
            $newLess = $data.find @lessOptions.less

            $items = $data.find @lessOptions.items
            if not $items.length
              $items = $data.filter @lessOptions.items

            oldTop =  $(@lessWaypoint.context.element).scrollTop()
            @$container.prepend $items
            itemHeight = $items.outerHeight()
            $(@lessWaypoint.context.element).scrollTop(oldTop + itemHeight*$items.length)

            if not $newLess.length
              $newLess = $data.filter @lessOptions.less
            if $newLess.length
              @$less.replaceWith $newLess
              @$less = $newLess
              @lessWaypoint = new Waypoint @lessOptions
            else
              @$less.remove()
          this))

      this
    )




jQuery(document).ready ($) ->

  # If there's an infinite scrolling pager, configure it:
  if $('#js-infinite-scrolling').length == 1
    infiniteScroll = new BothInfinite({
      element: $('[data-role="infinite-scroll"]')[0]
      container: $('[data-role="infinite-content"]')[0]
      items: '[data-role="infinite-content"] > tr'
      more: '.pagination a.next_page'
      less: '.pagination a.previous_page'
      onBeforePageLoad: () ->
        $('[data-role="infinite-status"]').removeClass 'hide'
      onAfterPageLoad: (items) ->
        $('[data-role="infinite-status"]').addClass 'hide'
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
