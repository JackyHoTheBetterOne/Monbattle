$ ->
  name = undefined
  $(document).on "click.filter_levels", ".map-level", ->
    $(".level-description").fadeOut(300)
    setTimeout (->
      $(".level-description").fadeIn(300)
      ), 500
  $(document).on "click.filter_areas", ".region-select", ->
    name = $(this)[0]
    setTimeout (->
      $(".map-level")[0].click()
    ), 500