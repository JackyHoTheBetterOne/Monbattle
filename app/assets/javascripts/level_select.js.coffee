$ ->
  if window.location.href.indexOf("battles/new") isnt -1
    if typeof document.getElementsByClassName("map-image")[0] isnt "undefined"
      region_name = document.getElementsByClassName("map-image")[0].getAttribute("data-region") 
      document.getElementById(region_name).className += " current-region"
      id = document.getElementsByClassName("party_edit_button")[0].getAttribute("data-latest-level")
      document.getElementById(id).className += " latest-level" if document.getElementById(id)
  $(document).on "click.filter_levels", ".map-level", ->
    area_index = $(".map-level").index($(this))
    area = $(this)
    $(".level-description").fadeOut(300)
    setTimeout (->
      $(".level-description").fadeIn(300)
      document.getElementsByClassName("map-level")[area_index].className += " current-area"
      id = document.getElementsByClassName("party_edit_button")[0].
            getAttribute("data-latest-level")
      document.getElementById(id).className += " latest-level" if document.getElementById(id)
    ), 500
  $(document).on "click.filter_areas", ".region-select", ->
    $(".map-image, .map-level").fadeOut(300)
    setTimeout (->
      $(".map-image, .map-level").fadeIn(300)
      id = document.getElementsByClassName("party_edit_button")[0].
            getAttribute("data-latest-level")
      document.getElementById(id).className += " latest-level" if document.getElementById(id)
    ), 400
    setTimeout (->
      index = document.getElementsByClassName("map-level").length-1
      document.getElementsByClassName("map-level")[index].className += " current-area"
    ), 800
    index = $(".region-select").index($(this))
    i = 0
    while i < document.getElementsByClassName("region-select").length
      document.getElementsByClassName("region-select")[i].className = "btn btn-primary region-select"
      i++
    document.getElementsByClassName("region-select")[index].className += " current-region"
  $(document).on "click.select_level", ".pick-level", ->
    $(this).click(false)
  $(document).on("mouseover.challenge", ".pick-level", ->
    $(".stage-challenge-description").css("z-index", "10000")
    $(".stage-challenge-description").css("opacity", "0.95")
    document.getElementsByClassName("stage-name")[0].innerHTML = 
      $(this).children(".stage-stars").data("name")
    document.getElementsByClassName("reward-desc")[1].innerHTML = 
      "Currency. Completion bonus: " + $(this).children(".stage-stars").data("reward")
    document.getElementsByClassName("objective-desc")[1].innerHTML = 
      "Complete the level under " + $(this).children(".stage-stars").data("requirement") + " rounds"
  ).on "mouseleave.challenge", ".pick-level", ->
    $(".stage-challenge-description").css("opacity", "0")
    $(".stage-challenge-description").css("z-index", "-1")

