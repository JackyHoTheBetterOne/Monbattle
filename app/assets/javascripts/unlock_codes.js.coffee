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
        alert("Wrong code, buddy.")
      success: (response) ->
        document.getElementsByClassName("redeem-overlay")[0].innerHTML += response
