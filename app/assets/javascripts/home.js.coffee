# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $(document).on "click", ".monImg", ->
    $(this).effect("highlight")
    window.mon_unlock_id = $(this).attr("id")
    $(".abilities-display-area").hide().empty()
    mon_info = $("#" + mon_unlock_id + "-info").html()
    socket1 = $("#" + mon_unlock_id + "-socket1").html()
    socket2 = $("#" + mon_unlock_id + "-socket2").html()
    $(".monster-info").html(mon_info).hide().show("fadeIn")
    $(".equip1").html(socket1).attr("id", mon_unlock_id + "-socket1-div")
    $(".equip2").html(socket2).attr("id", mon_unlock_id + "-socket2-div")

  $(document).on "click", ".equip1", ->
    socket1_abil_avail = $("#" + mon_unlock_id + "-socket1-abils").contents()
    $(".abilities-display-area").html(socket1_abil_avail)
    $(".abilities-display-area").hide().slideDown()

  $(document).on "click", ".equip2", ->
    socket2_abil_avail = $("#" + mon_unlock_id + "-socket2-abils").contents()
    $(".abilities-display-area").html(socket2_abil_avail)
    $(".abilities-display-area").hide().slideDown()

  # $(document).on "click", ".equip2", ->
  #   socket1_abil_avail = $("#" + mon_unlock_id + "-socket2-abils")
  #   $(".abilities-display-area").html(socket2_abil_avail)

  # $(document).on "click", ".equip2", ->
  #   socket1_abil_avail = $("#" + mon_unlock_id + "-socket2-abils")
  #   $(".abilities-display-area").html(socket2_abil_avail)






