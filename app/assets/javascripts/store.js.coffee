# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $(document).on "mouseover", ".king-roll", ->
    $(this).attr("src", "../assets/summon-button-mouseover.png")
  $(document).on "mouseleave", ".king-roll", ->
    $(this).attr("src", "../assets/summon-button.png")

  $.ajax 
    url: "/store"
    method: "get"
    dataType: "json"
    error: ->
      alert("Cannot get the latest abilities")
    success: (response) ->
      window.latest_abilities = response
  $(document).on "click", ".king-roll", ->
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
        overlay.className += " fadeIn-1s"
        gp.innerHTML = response.gp 
        message.innerHTML = response.message
    $(document).on "click", ->
      overlay = document.getElementsByClassName("store-overlay")[0]
      overlay.classList.remove("fadeIn-1s")
  $(document).on "mouseover", ".showcase", ->
    $(".ability-detail").text latest_abilities[$(this).data("index")].description
