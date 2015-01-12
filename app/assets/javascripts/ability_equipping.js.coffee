$ ->
  $(document).on "click", ".equip-search-cross", ->
    document.getElementsByClassName("monster-equip-search-words")[0].value = ""
    setTimeout (->
      document.getElementsByClassName("monster-equip-search")[0].click()
    ), 250