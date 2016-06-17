class BothInfinite extends Waypoint.Infinite
  constructor: (options) ->
    super(options)
    @$less = jQuery @options.less
    if @$less.length
      @lessOptions = jQuery.extend {}, @options, offset: 0
      @setupLessHandler()
      @lessWaypoint = new Waypoint @lessOptions
      @$window = jQuery @lessWaypoint.context.element

  setupLessHandler: () ->
    @lessOptions.handler = jQuery.proxy(
      (direction) ->
        @$container.addClass @lessOptions.loadingClass
        if direction == 'down'
          return
        if @lessWaypoint
          @lessWaypoint.destroy()
        $oldFirstItem = jQuery(document).find(@lessOptions.items).first()
        itemHeight = $oldFirstItem.outerHeight()

        jQuery.get(@$less.attr('href'), jQuery.proxy(
          (data) ->
            $data = jQuery(jQuery.parseHTML data)
            $newLess = $data.find @lessOptions.less
            $items = $data.find @lessOptions.items
            if not $items.length
              $items = $data.filter @lessOptions.items
            @$container.prepend $items
            @$window.scrollTop itemHeight*$items.length + @$window.scrollTop()

            if not $newLess.length
              $newLess = $data.filter @lessOptions.less
            if $newLess.length
              @$less.replaceWith $newLess
              @$less = $newLess
              @lessWaypoint = new Waypoint @lessOptions
            else
              @$less.remove()

            @lessOptions.onAfterPageLoad $items
          this))
      this
    )

window.BothInfinite = BothInfinite
