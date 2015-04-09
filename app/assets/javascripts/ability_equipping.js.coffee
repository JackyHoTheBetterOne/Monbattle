$ ->
  $(document).off "click", ".equip-search-cross"
  $(document).on "click", ".equip-search-cross", ->
    document.getElementsByClassName("monster-equip-search-words")[0].value = ""
    setTimeout (->
      document.getElementsByClassName("monster-equip-search")[0].click()
    ), 250
  $(document).off("mouseover.passive", ".equipping-passive-image")
  $(document).on("mouseover.passive", ".equipping-passive-image", ->
    $(this).next().css("opacity", "1")
  ).on "mouseleave.passive", ".equipping-passive-image", ->
    $(this).next().css("opacity", "0")
  if window.location.href.indexOf("home") isnt -1
    setTimeout (->
      $(".mon-thumb img")[0].click() 
      ), 250
  $(document).off("click.equip-link", ".equip-link")
  $(document).on "click", ".equip-link", ->
    $(".shadowed2").css("border", "none")
    $(this).parent().css("border", "2px solid yellow")
  $(document).off("click.mon-highlight", ".mon-thumb img")
  $(document).on "click.mon-highlight", ".mon-thumb img", ->
    $(".mon-equipped1.shadowed2").css("border", "2px solid yellow")