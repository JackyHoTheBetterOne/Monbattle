# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

window.setPanelInfo = ->
  mon_info = $("#" + mon_unlock_id + "-info").html()
  setSocketIcon(1)
  setSocketIcon(2)
  $(".monster-info").html(mon_info).hide().show("fadeIn")
  $(".abilities-display-area").hide().empty()

window.setSocketIcon = (socket_num) ->
  socketFor = $("#" + mon_unlock_id + "-socket" + socket_num).html()
  $(".equip" + socket_num).html(socketFor).attr("id", mon_unlock_id + "-socket" + socket_num + "-div").hide().show()

window.setMonButtons = ->
  evolve_unlock_id = $("." + mon_unlock_id + "-evolve-id").attr("id")
  $(".btn-box").show()
  $(".btn-base").attr("id", mon_unlock_id)
  $(".btn-evolve").removeAttr("id").attr("id", evolve_unlock_id)

window.setAbilAvail = (sockNum) ->
  getAbilAvail = $("#" + mon_unlock_id + "-socket" + sockNum + "-abils")
  $(".abilities-display-area").html(getAbilAvail)
  $(".abilities-display-area").hide().slideDown()

window.setMonsterInfoOnClick = ->
    window.mon_unlock_id = $(this).attr("id")
    $(this).effect("highlight")
    setPanelInfo()
    setAbilAvail(1)

$ ->

  $(".monImg").draggable({revert: true})
  $(".member-image").droppable({activeClass: "ui-state-highlight"}, {accept: ".monImg"})

  $(document).on "click", ".monImg", ->
    window.mon_unlock_id = $(this).attr("id")
    $(this).effect("highlight")
    setPanelInfo()
    setMonButtons()
    setAbilAvail(1)

  $(document).on "click", ".btn-evolve", ->
    window.mon_unlock_id = $(this).attr("id")
    $(this).effect("highlight")
    setPanelInfo()
    setAbilAvail(1)

  $(document).on "click", ".btn-base", ->
    window.mon_unlock_id = $(this).attr("id")
    $(this).effect("highlight")
    setPanelInfo()
    setAbilAvail(1)

  $(document).on "click", ".equip1", ->
    setAbilAvail(1)

  $(document).on "click", ".equip2", ->
    setAbilAvail(2)