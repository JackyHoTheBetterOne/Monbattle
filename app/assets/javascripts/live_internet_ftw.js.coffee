# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  window.dickCount = 0
  window.dispatcher = new WebSocketRails('localhost:3000/websocket')
  dispatcher.bind 'dick_love', (data) ->
    number = parseInt(document.getElementsByClassName("dick_count")[0].innerHTML)
    number += parseInt(data.count)
    document.getElementsByClassName("dick_count")[0].innerHTML = number
    return
  $(".dick_trap").on "click", ->
    new_message = {}
    new_message["dick_count"] = 1
    dispatcher.trigger('dick_love', new_message)
