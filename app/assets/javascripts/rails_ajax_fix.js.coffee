window.reloadObjects = (obj, but) -> 
  if window.location.href.indexOf(obj) isnt -1
    setTimeout (->
      document.getElementsByClassName(but)[0].click() 
      ), 500

window.fixTurbo = () ->
  setTimeout (->
    reloadObjects("regions", "region-search")
    reloadObjects("battle_levels", "level-search")
    reloadObjects("cut_scenes", "scene-search")
    reloadObjects("quests", "quest-search")
    reloadObjects("notices", "notice-search")
  ), 500

$ ->
  fixTurbo()