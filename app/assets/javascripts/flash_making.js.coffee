window.flashMaking = ->
  if document.getElementsByClassName("flash-store").length isnt 0 and 
      document.getElementsByClassName("abil-note").length isnt 0
    document.getElementsByClassName("flash-store")[0].innerHTML= "" 
  setTimeout (->
    if typeof window.newAbilities isnt "undefined"
      flash_array = window.newAbilities.concat(window.newAbilitiesLearned).concat(window.newMonsters)
      i = 0
      while i < flash_array.length
        html = "<div class='alert alert-info fade in ability abil-note' role='alert'>
                <button type='button' class='close' data-dismiss='alert'>
                  <span aria-hidden='true'>×</span>
                  <span class='sr-only'>Close</span>
                </button>"
        html += flash_array[i]
        html += " </div>" 
        $(".flash-store").append(html)
        $(".fade.in.ability").css("opacity", "1").addClass("tada animated")
        i++
  ), 250

$ ->
  flashMaking()
