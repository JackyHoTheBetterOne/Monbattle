# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $.ajax 
    url: "http://localhost:3000/store"
    method: "get"
    dataType: "json"
    error: ->
      alert("Cannot get the latest abilities")
    success: (response) ->
      window.latest_abilities = response
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
  $(document).on "mouseover", ".showcase", ->
    $(".ability-detail").text latest_abilities[$(this).data("index")].description
