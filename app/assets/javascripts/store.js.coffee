# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $(document).off "click.roll"
  $(document).on "mouseover", ".king-roll", ->
    $(this).attr("src", "https://s3-us-west-2.amazonaws.com/monbattle/images/summon-button-mouseover.png")
  $(document).on "mouseleave", ".king-roll", ->
    $(this).attr("src", "https://s3-us-west-2.amazonaws.com/monbattle/images/summon-button.png")
  $(document).on "click.roll", ".king-roll", ->
    $.ajax 
      url: "/home/roll_treasure"
      method: "get"
      dataType: "json"
      error: ->
        alert("Can't process the roll")
      success: (response) ->
        overlay = document.getElementsByClassName("store-overlay")[0]
        gp = document.getElementById("summoner-gp")
        message = document.getElementsByClassName("roll-message")[0]
        button = document.getElementsByClassName("back-to-store")[0]
        overlay.className += " fadeIn-1s"
        gp.innerHTML = response.gp 
        message.innerHTML = response.message
        setTimeout (->
          message.className += " bounceIn animated"
          button.className += " bounceIn animated"
        ), 1000
    $(document).on "click", ".back-to-store", ->
      document.getElementsByClassName("store-overlay")[0].className = "store-overlay"
      document.getElementsByClassName("back-to-store")[0].className = "back-to-store"
      document.getElementsByClassName("roll-message")[0].className = "panel-body roll-message"
  $(document).on "mouseover", ".showcase", ->
    $(".ability-detail").text latest_abilities[$(this).data("index")].description
