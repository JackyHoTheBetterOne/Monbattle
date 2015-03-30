# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $(".submit-code-button").on "click", ->
    code = $(".redeem-form-text-field").val()
    $.ajax 
      url: "/unlock_codes/unlock"
      method: "POST"
      data: { code_entered: code }
      error: ->
        $(".redeem-form-text-field").effect("highlight", {color: "red"})
        $(".redeem-form .instruction").text("Wrong code or used code, Buddy!")
      success: (response) ->
        object = response
        console.log(response)
        image = undefined
        $(".backer-name").text(object.namey)
        $(".reward-icon").attr("src",object.image)
        $(".unlock-reward-name").text(object.item_name)
        $(".redeem-form").css("opacity", "0")
        setTimeout (->
          $(".unlock-code-reward-screen").css("opacity", "1")
          $(".redeem-form .instruction").text("")
          $(".redeem-form-text-field").val("")
        ), 500

