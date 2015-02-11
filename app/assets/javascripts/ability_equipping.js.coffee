$ ->
  $(document).off "click", ".equip-search-cross"
  $(document).on "click", ".equip-search-cross", ->
    document.getElementsByClassName("monster-equip-search-words")[0].value = ""
    setTimeout (->
      document.getElementsByClassName("monster-equip-search")[0].click()
    ), 250
  $(document).on("mouseover.passive", ".equipping-passive-image", ->
    $(this).next().css("opacity", "1")
  ).on "mouseleave.passive", ".equipping-passive-image", ->
    $(this).next().css("opacity", "0")
  if window.location.href.indexOf("home") isnt -1
    setTimeout (->
      $(".mon-thumb img")[0].click() 
      ), 250
  $(document).on "click", ".equip-link", ->
    $(".shadowed2").css("border", "none")
    $(this).parent().css("border", "2px solid yellow")
  $(document).on "click", ".mon-thumb img", ->
    $(".mon-equipped1.shadowed2").css("border", "2px solid yellow")