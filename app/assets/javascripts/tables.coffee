

# Function to obtain 'page' param and anchor to point to a specific item in listings
obtainPageAndAnchor = (searchString, page, itemid) ->
  oldSearch = searchString.replace(/^\??/, '?').split('#')[0]
  if oldSearch.match(/page=\d+/)
    newSearch = oldSearch.replace(/page=\d+/, "page=#{page}")
  else
    newSearch = "#{oldSearch}&page=#{page}"
  newSearch = "#{newSearch}##{itemid}"

# Function to change url according to first item in list and page number
changeUrl = ($item) ->
  page = $item.data 'page'
  itemid = $item.data 'itemid'
  newSearch = obtainPageAndAnchor document.location.search, page, itemid
  newUrl = "#{document.location.pathname}#{newSearch}"
  if $item.data 'page-start'
    window.history.pushState {}, 'kiko', newUrl
  else
    window.history.replaceState {}, 'kiko', newUrl


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
          waypoint = new Waypoint({
            element: item
            offset: "10%"
            handler: (direction) ->
              changeUrl $(item)
          })
    })
    # waypoints to change history
    $('[data-role="infinite-content"] > tr').each (counter, item) ->
      waypoint = new Waypoint({
        element: item
        offset: "10%"
        handler: (direction) ->
          changeUrl $(item)
      })



  # if there's anchor or page param, jump to the item
  if '#' in window.location.href
    $firstItem = $(document).find("[data-role='infinite-content'] >
      tr[data-itemid='#{window.location.href.split('#')[1]}']")
  if not ($firstItem and $firstItem.length) and window.location.search.match /page=/
    $firstItem = $(document).find("[data-role='infinite-content'] > tr").first()
  if $firstItem
    $(window).scrollTop $firstItem.offset().top - $firstItem.outerHeight()


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
