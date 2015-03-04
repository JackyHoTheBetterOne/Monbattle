$ ->
  $(document).off "click.enhance", ".enhance-monster-but"
  $(document).on "click.enhance", ".enhance-monster-but", ->
    setTimeout (->
      document.getElementsByClassName("level-up-text")[0].className += " bounceIn animated"
      document.getElementsByClassName("level-up-text")[0].style["opacity"] = "1"
      if document.getElementsByClassName("enhance-monster-but")
        document.getElementsByClassName("enhance-monster-but")[0].style.pointerEvents = "none"
    ), 800
    setTimeout (->
      document.getElementsByClassName("level-up-text")[0].className = "level-up-text"
      document.getElementsByClassName("level-up-text")[0].className += " bounceOut animated"
      if document.getElementsByClassName("enhance-monster-but")
        document.getElementsByClassName("enhance-monster-but")[0].style.pointerEvents = "auto"
    ), 2000