$ ->  
  $(document).off "click.ascension"
  $(document).off "mouseover.ascend-passive"
  $(document).off "mouseleave.ascend-passive"
  $(document).on "click.ascension", ".unlock-ascension-but", (event) ->
    cost = parseInt(document.getElementsByClassName("material-box")[0].
                      getAttribute("data-aspcost"))
    existing = parseInt(document.getElementsByClassName("material-box")[0].
                        getAttribute("data-asp"))
    name = document.getElementsByClassName("material-box")[0].getAttribute("data-name")
    baby_name = document.getElementsByClassName("baby-name")[0].innerHTML
    element = $(this)
    if existing >= cost 
      document.getElementsByClassName("ascend-overlay")[0].style["z-index"] = "10000"
      document.getElementsByClassName("ascend-overlay")[0].style["opacity"] = "0.95"
      setTimeout (->
        document.getElementsByClassName("ascend-face")[0].className += " ascension-unlocked"
        document.getElementById("ascension-name").innerHTML = name.toString()
        $("#" + baby_name).remove()
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
    else
      event.preventDefault()
      $(element).effect("highlight", {color: "red"}, 200)
  $(document).on("mouseover.ascend-passive", ".ascension-box .passive-icon", ->
    document.getElementsByClassName("passive-description")[0].style["opacity"] = "1"
  ).on "mouseleave.ascend-passive", ".ascension-box .passive-icon", ->
    document.getElementsByClassName("passive-description")[0].style["opacity"] = "0"


