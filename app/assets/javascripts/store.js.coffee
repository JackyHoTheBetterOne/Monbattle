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
        document.getElementsByClassName("king-roll")[0].style["z-index"] = "-1"
        overlay = document.getElementsByClassName("store-overlay")[0]
        gp = document.getElementById("summoner-gp")
        message = document.getElementsByClassName("roll-message")[0]
        button = document.getElementsByClassName("back-to-store")[0]
        rarity = document.getElementsByClassName("rarity-icon")[0]
        ability_icon = document.getElementsByClassName("ability-won-icon")[0]
        reveal_but = document.getElementsByClassName("reveal-button")[0]
        if response.image isnt "1"
          ability_icon.setAttribute("src", response.image)
        else
          ability_icon.setAttribute("src", "https://s3-us-west-2.amazonaws.com/monbattle/images/frank.jpg")
        document.getElementsByClassName("rarity-icon")[0].
          setAttribute("src", response.rarity_image)
        overlay.className += " fadeIn-1s"
        gp.innerHTML = response.gp 
        if response.type == "ability"
          sentence = "You have gained " + response.reward + 
                     "! Teach it to your monster through the " + 
                     "<a href='/learn_ability'>Ability Learning</a>" + " page!" 
          newAbilities.push(sentence)
        setTimeout (->
          message.style["opacity"] = "1"
        ), 1000
        setTimeout (->
          rarity.className += " zoomIn animated"
          rarity.style["opacity"] = "1"
          setTimeout (->
            reveal_but.style["z-index"] = "1000"
            reveal_but.style["opacity"] = "1"
            reveal_but.style["display"] = ""
            $(".reveal-button").on("mouseover.reveal", ->
              $(this).css("box-shadow", response.rarity_color)
            ).on "mouseleave.reveal", ->
              $(this).css("box-shadow", "")
            $(".reveal-button").on "click.reveal", ->
              reveal_but.className += " bounceOut animated"
              setTimeout (->
                reveal_but.className = "reveal-button"
                reveal_but.style["z-index"] = "-1"
                reveal_but.style["opacity"] = "0"
                button.style["z-index"] = "1000"
                button.className += " bounceIn animated"
                message.innerHTML = response.message
                ability_icon.className += " bounceIn animated"
              ), 840
          ), 600
        ), 1500


    $(document).on "click", ".back-to-store", ->
      document.getElementsByClassName("store-overlay")[0].className = "store-overlay"
      document.getElementsByClassName("back-to-store")[0].className = "back-to-store"
      document.getElementsByClassName("back-to-store")[0].style["z-index"] = "-1"
      document.getElementsByClassName("roll-message")[0].style["opacity"] = "0"
      document.getElementsByClassName("ability-won-icon")[0].className = "ability-won-icon"
      document.getElementsByClassName("rarity-icon")[0].style["opacity"] = "0"
      document.getElementsByClassName("rarity-icon")[0].className = "rarity-icon"
      document.getElementsByClassName("roll-message")[0].innerHTML = ""
      document.getElementsByClassName("king-roll")[0].style["z-index"] = "1000"
  $(document).on "mouseover", ".showcase", ->
    $(".ability-detail").text latest_abilities[$(this).data("index")].description


