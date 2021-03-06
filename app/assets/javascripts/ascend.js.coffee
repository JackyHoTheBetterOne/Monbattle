$ ->  
  $(document).off "click.ascension"
  $(document).off "mouseover.ascend-passive"
  $(document).off "mouseleave.ascend-passive"
  $(".ascend-info-icon").on("mouseover", ->
    $(".ascend-explanation").css("z-index", "1000").css("opacity", "1")
  ).on "mouseleave", ->
    $(".ascend-explanation").css("opacity", "0")
    setTimeout (->
      $(".ascend-explanation").css("opacity", "0")
    ), 350
  $(document).on "click.ascension", ".unlock-ascension-but", (event) ->
    object = {}
    object["eventName"] = "SPENT_CREDITS"
    object["value"] = document.getElementsByClassName("material-box")[0].getAttribute("data-aspcost")
    object["params"] = {}
    object["params"][FB.AppEvents.ParameterNames.CONTENT_TYPE] = "Ascension"
    object["params"][FB.AppEvents.ParameterNames.CONTENT_ID] = "asp"
    facebookAnalytics(object) if window.name != ""
    cost = parseInt(document.getElementsByClassName("material-box")[0].
                      getAttribute("data-aspcost"))
    existing = parseInt(document.getElementsByClassName("material-box")[0].
                        getAttribute("data-asp"))
    name = document.getElementsByClassName("material-box")[0].getAttribute("data-name")
    baby_name = document.getElementsByClassName("baby-name")[0].innerHTML.replace(" ","")
    element = $(this)
    if existing >= cost 
      document.getElementsByClassName("ascend-overlay")[0].style["z-index"] = "10000"
      document.getElementsByClassName("ascend-overlay")[0].style["opacity"] = "0.95"
      setTimeout (->
        document.getElementsByClassName("ascend-face")[0].className += " ascension-unlocked"
        document.getElementById("ascension-name").innerHTML = name.toString()
        $("#" + baby_name).css("opacity", "0")
        setTimeout (->
          $("#" + baby_name).remove()
        ), 500
      ), 400
      setTimeout (->
        document.getElementsByClassName("unlock-message")[0].style["opacity"] = "1"
        document.getElementsByClassName("ascend-face")[0].className += " tada animated"
        document.getElementsByClassName("unlock-message")[0].className += " tada animated"
      ), 1600
      setTimeout (->
        $(".ascend-monster").effect("explode", {pieces: 20}, 500)
        if document.getElementsByClassName("ascend-mon-avatar").length == 0
          document.getElementsByClassName("ascend-list")[0].innerHTML = ""
          document.getElementsByClassName("list-title")[0].innerHTML = "You have unlocked all ascensions!"
      ), 3200
      setTimeout (->
        $(".ascend-info-icon").effect("shake")
        if document.getElementsByClassName("ascending")[0].getAttribute("data-firsttime") is "true"
          setTimeout (->
            hopscotch.startTour(ascension_tour)
          ), 500
      ), 4000
    else
      event.preventDefault()
      $(element).effect("highlight", {color: "red"}, 200)
  $(document).on("mouseover.ascend-passive", ".ascension-box .passive-icon", ->
    document.getElementsByClassName("passive-description")[0].style["opacity"] = "1"
  ).on "mouseleave.ascend-passive", ".ascension-box .passive-icon", ->
    document.getElementsByClassName("passive-description")[0].style["opacity"] = "0"


