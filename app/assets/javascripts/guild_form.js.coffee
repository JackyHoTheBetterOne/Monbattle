$ ->
  if window.location.href.indexOf("/guilds/new") isnt -1
    GUILD_FORM = {
      name_typing_instruction: "*Maximum 15 characters",
      name_too_long_instruction: "*Name is too long",
      default_instruction: "*Required Field",
      name_uniqueness_instruction: "*Name has already been taken",
      name_ok_insturction: "*Name is OK",
      guild_form_name_instruction:  document.
        getElementsByClassName("guild-creation-instruction guild-name")[0],
      guild_form_description_instruction: document.
        getElementsByClassName("guild-creation-instruction guild-description")[0],
      guild_form_name_field: document.
        getElementsByClassName("guild_form_field guild_name_enter")[0],
      guild_form_description_field: document.
        getElementsByClassName("guild_form_field guild_description_enter")[0],
      submit_button: document.getElementsByClassName("guild-submit-button")[0]
      check_name_uniqueness: (value) ->
        object = this
        $.ajax
          url: "/guilds/check_name_uniqueness",
          method: "POST",
          data: { guild_name: value },
          success: (response) ->
            if response is "Yay"
              object.guild_form_name_instruction.innerHTML = object.name_ok_insturction
              object.submitEnabler()
            else
              object.guild_form_name_instruction.innerHTML = object.name_uniqueness_instruction
          error: ->
            alert("Shit happened!")
      submitEnabler: ->
        object = this
        if object.guild_form_name_instruction.innerHTML is object.name_ok_insturction &&
            object.guild_form_description_field.value isnt ""
          object.submit_button.removeAttribute("disabled")
          object.submit_button.style["opacity"] = "1"
        else 
          object.submit_button.setAttribute("disabled", true)
          object.submit_button.style["opacity"] = "0.5"
    }
    GUILD_FORM.submit_button.setAttribute("disabled", true)
    $(".guild_form_field.guild_name_enter").on "keyup", ->
      value = GUILD_FORM.guild_form_name_field.value
      if value is "" 
        GUILD_FORM.guild_form_name_instruction.innerHTML = GUILD_FORM.default_instruction
      else if value.length > 15
        GUILD_FORM.guild_form_name_instruction.innerHTML = GUILD_FORM.name_too_long_instruction
      else 
        GUILD_FORM.guild_form_name_instruction.innerHTML = GUILD_FORM.name_typing_instruction
        GUILD_FORM.submitEnabler()
    $(".guild_form_field.guild_description_enter").on "keypress", ->
      GUILD_FORM.guild_form_description_instruction.innerHTML = GUILD_FORM.default_instruction
      GUILD_FORM.submitEnabler()
    $("body").on "keyup", (evt) ->
      evt = evt || event
      value = GUILD_FORM.guild_form_name_field.value
      if evt.keyCode is 9 && value isnt "" && value.length <= 15
        GUILD_FORM.check_name_uniqueness()
        setTimeout (->
          GUILD_FORM.submitEnabler()
        ), 500
      else if evt.keyCode is 8
        GUILD_FORM.submitEnabler()
    $(".guild_form_field.guild_description_enter").on "click", ->
      value = GUILD_FORM.guild_form_name_field.value
      if value isnt "" && value.length <= 15
        GUILD_FORM.check_name_uniqueness(value)











