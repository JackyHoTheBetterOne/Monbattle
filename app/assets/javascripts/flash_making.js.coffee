window.flashMaking = ->
  i = 0
  while i < document.getElementsByClassName("alert-info").length
    document.getElementsByClassName("alert-info")[i].remove()
    i++
  setTimeout (->
    if typeof window.newAbilities isnt "undefined"
      flash_array = window.newAbilities
      i = 0
      while i < flash_array.length
        html = "<div class='alert alert-info fade in ability' role='alert'>
                <button type='button' class='close' data-dismiss='alert'>
                  <span aria-hidden='true'>×</span>
                  <span class='sr-only'>Close</span>
                </button>"
        html += flash_array[i]
        html += " </div>" 
        $(".flash-bank").append(html)
        $(".fade.in.ability").addClass("bounceIn animated")
        i++
  ), 100
  setTimeout (->
    if typeof window.newAbilitiesLearned isnt "undefined"
      flash_array = window.newAbilitiesLearned
      i = 0
      while i < flash_array.length
        html = "<div class='alert alert-info fade in ability' role='alert'>
                <button type='button' class='close' data-dismiss='alert'>
                  <span aria-hidden='true'>×</span>
                  <span class='sr-only'>Close</span>
                </button>"
        html += flash_array[i]
        html += " </div>" 
        $(".flash-bank").append(html)
        $(".fade.in.ability").addClass("bounceIn animated")
        i++
  ), 100

$ ->
  flashMaking()
