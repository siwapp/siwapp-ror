# Function to change url according to first item in list and page number
changeUrl = ($item) ->
  page = $item.data 'page'
  itemid = $item.data 'itemid'

  oldSearch = document.location.search.replace(/^\??/, '?').split('#')[0]

  if oldSearch.match(/page=\d+/)
    newSearch = oldSearch.replace(/page=\d+/, "page=#{page}")
  else
    newSearch = "#{oldSearch}&page=#{page}"

  newUrl = "#{document.location.pathname}#{newSearch}##{itemid}"

  if $item.data 'page-start'
    window.history.pushState {}, 'kiko', newUrl
  else
    window.history.replaceState {}, 'kiko', newUrl

# Function to add a Waypoint to change urls when scrolling through that item
addHistoryMilestone = (item) ->
  waypoint = new Waypoint({
    element: item
    offset: "10%"
    handler: (direction) ->
      changeUrl $(item)
  })


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
        # waypoint for changing history
        $(items).filter('tr[data-itemid]').each (counter, item) ->
          addHistoryMilestone(item)
    })
    # waypoints to change history
    $('[data-role="infinite-content"] > tr').each (counter, item) ->
      addHistoryMilestone(item)


    # if there's anchor or page param, jump to the item
    if '#' in window.location.href
      $firstItem = $(document).find("[data-role='infinite-content'] >
      tr[data-itemid='#{window.location.href.split('#')[1]}']")
    if not ($firstItem and $firstItem.length) and window.location.search.match /page=/
      $firstItem = $(document).find("[data-role='infinite-content'] > tr").first()
    if $firstItem
      $(window).scrollTop $firstItem.offset().top - $firstItem.outerHeight()


  # Hide buttons when we are in invoices and recurring_invoices listing
  if $('#js-list-form').length
    $('[data-role="action-buttons"]').hide()

  $(document)
    # Existing and future table rows with the data-href attribute will act as links
    .on 'click', 'tr[data-href]', (e) ->
      e.preventDefault()
      window.document.location = $(this).data("href")

    # but will let real links do their job
    .on 'click', 'tr[data-href] > td > a', (e) ->
      e.stopPropagation()

    # and avoid redirecting when clicking on a row-selection cell
    .on 'click', 'tr[data-href] [data-no-href]', (e) ->
      e.stopPropagation()

    # manage row selection
    .on 'click', ':checkbox[data-role="select-row"]', (e) ->
      table = $(this).closest('table')
      checkboxes = table.find(':checkbox[data-role="select-row"]')
      checkboxes_checked = checkboxes.filter(':checked')
      table.find(':checkbox[data-role="select-all-rows"]').prop('checked', checkboxes.length is checkboxes_checked.length)
      $('[data-role="action-buttons"]').toggle(checkboxes_checked.length > 0)

    # manage all rows selection
    .on 'click', ':checkbox[data-role="select-all-rows"]', (e) ->
      self = $(this)
      table = self.closest 'table'
      checked = self.is ':checked'

      table.find(':checkbox[data-role="select-row"]').prop('checked', checked);
      $('[data-role="action-buttons"]').toggle(checked)
