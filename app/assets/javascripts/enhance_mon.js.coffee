$ ->
  $(document).off "click.enhance", ".enhance-monster-but"
  $(document).on "click.enhance", ".enhance-monster-but", ->
    console.log("suck my dick")
    setTimeout (->
      document.getElementsByClassName("level-up-text")[0].className += " bounceIn animated"
      document.getElementsByClassName("level-up-text")[0].style["opacity"] = "1"
    ), 800
    setTimeout (->
      document.getElementsByClassName("level-up-text")[0].className = "level-up-text"
      document.getElementsByClassName("level-up-text")[0].className += " bounceOut animated"
    ), 2000