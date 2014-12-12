# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# window.setPanelInfo = ->
#   $(".monster-info-area").hide("fadeOut")
#   $("#" + mon_unlock_id + "-info-pane").show("slide", { direction: "left" }, 300 )
#   showSocket(1)

# window.showSocket = (socket_num) ->
#   $(".abilities-display-area").hide()
#   $("#" + mon_unlock_id + "-socket" + socket_num).show("slide", { direction: "up"}, 300)

# $ ->
#   $(document).on "click", ".monSet", ->
#     window.mon_unlock_id = $(this).attr("id")
#     setPanelInfo()

#   $(document).on "click", ".equip1", ->
#     $(this).toggle("puff", 80).toggle("puff", 35)
#     showSocket(1)

#   $(document).on "click", ".equip2", ->
#     $(this).toggle("puff", 80).toggle("puff", 35)
#     showSocket(2)