# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $(document).on "click", ".king-roll", ->
    $.ajax 
      url: "http://localhost:3000/home/roll"
      method: "get"
      dataType: "text"
      error: ->
        alert("Can't process the roll")
      success: (response) ->
        $(".roll-message").text(response)
        $(".store-overlay").fadeIn(100)
    $(document).on "click", ->
      $(".store-overlay").hide()