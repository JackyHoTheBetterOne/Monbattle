$ ->
  if window.location.href.indexOf("battles/new") isnt -1
    region_name = document.getElementsByClassName("map-image")[0].getAttribute("data-region")
    document.getElementById(region_name).className += " current-region"
  $(document).on "click.filter_levels", ".map-level", ->
    area_index = $(".map-level").index($(this))
    area = $(this)
    $(".level-description").fadeOut(300)
    setTimeout (->
      $(".level-description").fadeIn(300)
      document.getElementsByClassName("map-level")[area_index].className += " current-area"
    ), 1000
  $(document).on "click.filter_areas", ".region-select", ->
    $(".map-image, .map-level").fadeOut(300)
    setTimeout (->
      $(".map-image, .map-level").fadeIn(300)
    ), 500
    index = $(".region-select").index($(this))
    i = 0
    while i < document.getElementsByClassName("region-select").length
      document.getElementsByClassName("region-select")[i].className = 
      document.getElementsByClassName("region-select")[i].className.replace(" current-region", "")
      i++
    setTimeout (->
      document.getElementsByClassName("region-select")[index].className += " current-region"
    ), 1000
    $(".level-select").promise().done ->
      setTimeout (->
        $(".map-level").first().trigger("click")
      ), 750
  $(document).on "click.select_level", ".pick-level", ->
    $(this).click(false)

