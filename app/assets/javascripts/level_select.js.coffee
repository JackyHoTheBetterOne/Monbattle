$ ->
  if document.getElementsByClassName("pick-level").length is 1 && document.
      getElementsByClassName("pick-level")[0].id is "AreaA-Stage1"
    document.getElementsByClassName("pick-level")[0].innerHTML += 
      " <img src='https://s3-us-west-2.amazonaws.com/monbattle/images/quest-warning.png' class='latest-level-indication'>"
    document.getElementsByClassName("pick-level")[0].className += " latest-level"
    setTimeout (->
      document.getElementsByClassName("pick-level")[0].className += " tada animated latest-level"
    ), 500
  if window.location.href.indexOf("/battles/new") isnt -1
    if document.getElementsByClassName("battle_level")[0].getAttribute("data-newlevel") isnt ""
      setTimeout (->
        document.getElementsByClassName("latest-level")[0].style["z-index"] = "1000"
        document.getElementsByClassName("latest-level")[0].className += " tada animated"
      ), 500
  if window.location.href.indexOf("battles/new") isnt -1
    if typeof document.getElementsByClassName("map-image")[0] isnt "undefined"
      region_name = document.getElementsByClassName("map-image")[0].getAttribute("data-region") 
      document.getElementById(region_name).className += " current-region"
      id = document.getElementsByClassName("party_edit_button")[0].getAttribute("data-latest-level")
      if document.getElementById(id)
        element = document.getElementById(id)
        element.className += " latest-level" 
        element.innerHTML += " <img src='https://s3-us-west-2.amazonaws.com/monbattle/images/quest-warning.png' class='latest-level-indication'>"
  $(document).on "click.filter_levels", ".map-level", ->
    area_index = $(".map-level").index($(this))
    area = $(this)
    setTimeout (->
      document.getElementsByClassName("map-level")[area_index].className += " current-area"
      id = document.getElementsByClassName("party_edit_button")[0].
            getAttribute("data-latest-level")
      if document.getElementById(id)
        element = document.getElementById(id)
        element.className += " latest-level" 
        element.innerHTML += " <img src='https://s3-us-west-2.amazonaws.com/monbattle/images/quest-warning.png' class='latest-level-indication'>"
    ), 700
  $(document).on "click.filter_areas", ".region-select", ->
    $(".map-image, .map-level").fadeOut(300)
    setTimeout (->
      $(".map-image, .map-level").fadeIn(300)
      id = document.getElementsByClassName("party_edit_button")[0].
            getAttribute("data-latest-level")
      if document.getElementById(id)
        element = document.getElementById(id)
        element.className += " latest-level" 
        element.innerHTML += " <img src='https://s3-us-west-2.amazonaws.com/monbattle/images/quest-warning.png' class='latest-level-indication'>"
    ), 400
    setTimeout (->
      index = document.getElementsByClassName("map-level").length-1
      document.getElementsByClassName("map-level")[0].className += " current-area"
    ), 700
    index = $(".region-select").index($(this))
    i = 0
    while i < document.getElementsByClassName("region-select").length
      document.getElementsByClassName("region-select")[i].className = "btn btn-primary region-select"
      i++
    document.getElementsByClassName("region-select")[index].className += " current-region"
  $(document).on "click.select_level", ".pick-level", ->
    $(this).click(false)
  $(document).on("mouseover.challenge", ".pick-level", ->
    open_chest = "https://s3-us-west-2.amazonaws.com/monbattle/images/chest-open-55px.png"
    closed_chest = "https://s3-us-west-2.amazonaws.com/monbattle/images/chest-55px.png"
    $(".stage-challenge-description").css("z-index", "10000")
    $(".stage-challenge-description").css("opacity", "0.95")
    if $(this).children(".stage-stars").children(".first-star").attr("alt") is "Chest open"
      document.getElementsByClassName("description-star")[0].src = open_chest
    else 
      document.getElementsByClassName("description-star")[0].src = closed_chest
    if $(this).children(".stage-stars").children(".second-star").attr("alt") is "Chest open"
      document.getElementsByClassName("description-star")[1].src = open_chest
    else
      document.getElementsByClassName("description-star")[1].src = closed_chest
    document.getElementsByClassName("stage-name")[0].innerHTML = 
      $(this).children(".stage-stars").data("name")
    document.getElementsByClassName("reward-image")[0].src = 
      $(this).children(".stage-stars").data("firstclearimage")
    element = $(this)
    if $(element).data("currencyreward")
      document.getElementsByClassName("reward-count")[0].innerHTML = 
        "x" + " " + $(this).children(".stage-stars").data("firstclearreward")
    else
      document.getElementsByClassName("reward-count")[0].innerHTML = 
        $(this).children(".stage-stars").data("firstclearreward")
    document.getElementsByClassName("reward-image")[1].src = 
      $(this).children(".stage-stars").data("secondclearimage")
    document.getElementsByClassName("reward-count")[1].innerHTML = "x ?"
      # "x" + " " + $(this).children(".stage-stars").data("secondclearreward")
    document.getElementsByClassName("objective-desc")[1].innerHTML = 
      "Complete the level under " + $(this).children(".stage-stars").data("requirement") + " rounds"
  ).on "mouseleave.challenge", ".pick-level", ->
    $(".stage-challenge-description").css("opacity", "0")
    $(".stage-challenge-description").css("z-index", "-1")

