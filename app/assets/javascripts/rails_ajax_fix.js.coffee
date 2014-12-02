window.reloadObjects = (obj, but) -> 
  if window.location.href.indexOf(obj) isnt -1
    setTimeout (->
      $(but).trigger "click"
      ), 800

window.fixTurbo = () ->
  reloadObjects("regions", ".region-search")
  reloadObjects("battle_levels", ".level-search")
  reloadObjects("cut_scenes", ".scene-search")
  reloadObjects("quests", ".quest-search")
  reloadObjects("notices", ".notice-search")

$ ->
  fixTurbo()
  $(document).on "click", ".navbar.nav-admin .nav-btn-group .btn", fixTurbo