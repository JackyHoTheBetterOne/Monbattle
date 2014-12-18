# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $(document).on "mouseover", ".king-roll", ->
    $(this).attr("src", "https://s3-us-west-2.amazonaws.com/monbattle/images/summon-button-mouseover.png?X-Amz-Date=20141218T011526Z&X-Amz-Expires=300&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Signature=524d4b9c706e7d922e69054df46c4b9c2bf77e73683e13fae45752478d2e2736&X-Amz-Credential=ASIAIG4NS2BLCT3UE3ZQ/20141218/us-west-2/s3/aws4_request&X-Amz-SignedHeaders=Host&x-amz-security-token=AQoDYXdzEPf//////////wEakAIWBEI6A9pROr7PdR6ccHgciolRwKIIDMRxtbagmDiTztASIfp2C8XWdzjTS6Y/C/ahzb4MbBvlDGfVrkzvCufgucnnstFjpOGGdbRMjeXRw8qA35SJ6JHbpoVF9EWB70hbsnjB6xctheXXn47c56ktO38ZnoiqYlZc1S/A32WaQGZl6a/rrmlPetMlK/Z4sMbten2TCwP9HSZDOZ85zlJEX8hV7ceVMHwzBb%2BgnsUup49uKh6Kp4UA2LoKp2bi7C%2Buod1qOjrgpx/BfEr/snkfd7nJZXFPiFGIaA/HbasC%2Bv3uju4PPtxqXg%2BOb2Vc6nckINx/aoTwC3TxGY4R4cXxQWqk3oL8rpsJSeUog/4CYSC76sekBQ%3D%3D")
  $(document).on "mouseleave", ".king-roll", ->
    $(this).attr("src", "https://s3-us-west-2.amazonaws.com/monbattle/images/summon-button.png?X-Amz-Date=20141218T011304Z&X-Amz-Expires=300&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Signature=f44b54274805d7dbd4e043d478524c3c3580bc360f5a50143a1ed8d0b3c68f73&X-Amz-Credential=ASIAIG4NS2BLCT3UE3ZQ/20141218/us-west-2/s3/aws4_request&X-Amz-SignedHeaders=Host&x-amz-security-token=AQoDYXdzEPf//////////wEakAIWBEI6A9pROr7PdR6ccHgciolRwKIIDMRxtbagmDiTztASIfp2C8XWdzjTS6Y/C/ahzb4MbBvlDGfVrkzvCufgucnnstFjpOGGdbRMjeXRw8qA35SJ6JHbpoVF9EWB70hbsnjB6xctheXXn47c56ktO38ZnoiqYlZc1S/A32WaQGZl6a/rrmlPetMlK/Z4sMbten2TCwP9HSZDOZ85zlJEX8hV7ceVMHwzBb%2BgnsUup49uKh6Kp4UA2LoKp2bi7C%2Buod1qOjrgpx/BfEr/snkfd7nJZXFPiFGIaA/HbasC%2Bv3uju4PPtxqXg%2BOb2Vc6nckINx/aoTwC3TxGY4R4cXxQWqk3oL8rpsJSeUog/4CYSC76sekBQ%3D%3D")

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
