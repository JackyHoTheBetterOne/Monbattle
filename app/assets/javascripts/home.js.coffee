# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

window.setPanelInfo = ->
  $(".monster-info-area").hide("fadeOut")
  $("#" + mon_unlock_id + "-info-pane").show("fadeIn")
  showSocket(1)

window.showSocket = (socket_num) ->
  $(".abilities-display-area").hide()
  $("#" + mon_unlock_id + "-socket" + socket_num).slideDown()

$ ->
  $(document).on "click", ".monSet", ->
    window.mon_unlock_id = $(this).attr("id")
    $(this).effect("shake", 5, 5)
    setPanelInfo()

  $(document).on "click", ".equip1", ->
    $(this).effect("highlight")
    showSocket(1)

  $(document).on "click", ".equip2", ->
    $(this).effect("highlight")
    showSocket(2)