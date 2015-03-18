# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $(".submit-unlock-code").on "click", ->
    code = $(".unlock-code-entered").val()
    console.log(code)
    $.ajax 
      url: "/unlock_codes/unlock"
      method: "POST"
      data: { code_entered: code }
      error: ->
        alert("Wrong code, buddy.")
      success: (response) ->
        console.log(response)
