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
    ), 600
  $(document).on "click.filter_areas", ".region-select", ->
    $(".map-image, .map-level").fadeOut(300)
    setTimeout (->
      $(".map-image, .map-level").fadeIn(300)
    ), 300
    setTimeout (->
      document.getElementsByClassName("map-level")[0].className += " current-area"
    ), 750
    index = $(".region-select").index($(this))
    i = 0
    while i < document.getElementsByClassName("region-select").length
      document.getElementsByClassName("region-select")[i].className = "btn btn-primary region-select"
      i++
    document.getElementsByClassName("region-select")[index].className += " current-region"
  $(document).on "click.select_level", ".pick-level", ->
    $(this).click(false)

