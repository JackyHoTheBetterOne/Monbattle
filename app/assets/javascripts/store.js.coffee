# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  if typeof storeDisplay isnt "undefined"
    if storeDisplay is true
      $(".gem-store-tab").click()
      window.storeDisplay = false
  window["ascension_roll"] = "gp"
  window["base_roll"] = "gp"
  window["monster_roll"] = "gp"
  $(document).off "click.roll"
  $(document).on "mouseover", ".king-roll, .queen-roll, .mon-roll", ->
    $(this).attr("src", "https://s3-us-west-2.amazonaws.com/monbattle/images/summon-button-mouseover.png")
  $(document).on "mouseleave", ".king-roll, .queen-roll, .mon-roll", ->
    $(this).attr("src", "https://s3-us-west-2.amazonaws.com/monbattle/images/summon-button.png")
  $(document).on "click", ".store-tabs .tab", ->
    document.getElementsByClassName("monster-store-tab")[0].className = "monster-store-tab tab"
    document.getElementsByClassName("ability-store-tab")[0].className = "ability-store-tab tab"
    document.getElementsByClassName("gem-store-tab")[0].className = "gem-store-tab tab"
    tab = $(this).data("tab")
    $(".store-front").not("#"+tab).css({"opacity":"0", "z-index":"-1000"})
    $(this).addClass("current-tab")
    document.getElementById(tab).style["opacity"] = "1"
    document.getElementById(tab).style["z-index"] = "1000"
  $(document).on "click", ".current-toggle-but", ->
    window[$(this).data("rolltype") + "_roll"] = $(this).data("currencytype")
    $(this).parent().children(".current-toggle-but").removeClass("current-currency-toggle")
    $(this).addClass("current-currency-toggle")
  $(document).on "click.roll", ".king-roll, .queen-roll, .mon-roll", ->
    roll = $(this).data("roll")
    $.ajax 
      url: "/home/roll_treasure"
      method: "get"
      dataType: "json"
      data: {
        roll_type: roll,
        currency_type: window[roll+"_roll"],
      }
      error: ->
        alert("Can't process the roll")
      success: (response) ->
        $(".share-roll-but").on "click", ->
          caption = document.getElementsByClassName("username")[0].innerHTML + " is playing monbattle!"
          name = document.getElementsByClassName("username")[0].innerHTML + " has unlocked a " + response.rarity + " " + response.type + ", " + response.reward + ", " + " in Monbattle!"
          picture_url = response.image
          monbattleShare(caption, picture_url, name, showHome)
        document.getElementsByClassName("king-roll")[0].style["z-index"] = "-1"
        document.getElementsByClassName("queen-roll")[0].style["z-index"] = "-1"
        document.getElementsByClassName("mon-roll")[0].style["z-index"] = "-1"
        overlay = document.getElementsByClassName("store-overlay")[0]
        gp = document.getElementById("summoner-gp")
        mp = document.getElementById("summoner-mp")
        message = document.getElementsByClassName("roll-message")[0]
        stats = document.getElementsByClassName("ability-won-stats")[0]
        impact = document.getElementsByClassName("impact")[0]
        apcost = document.getElementsByClassName("ap-cost")[0]
        sword = document.getElementsByClassName("sword-icon")[0]
        button = document.getElementsByClassName("back-to-store")[0]
        share = document.getElementsByClassName("share-roll-but")[0]
        rarity = document.getElementsByClassName("rarity-icon")[0]
        ability_icon = document.getElementsByClassName("ability-won-icon")[0]
        description_box = document.getElementsByClassName("ability-won-description")[0]
        reveal_but = document.getElementsByClassName("reveal-button")[0]
        if response.image isnt "1"
          ability_icon.setAttribute("src", response.image)
        else
          ability_icon.setAttribute("src", "https://s3-us-west-2.amazonaws.com/monbattle/images/frank.jpg")
        document.getElementsByClassName("rarity-icon")[0].
          setAttribute("src", response.rarity_image)
        overlay.className += " fadeIn-1s"
        gp.innerHTML = response.gp 
        mp.innerHTML = response.mp
        description_box.innerHTML = response.desc + "<br />" + response.job_list
        if response.type == "ability" && response.first_time == true
          sentence = "You have earned " + response.reward + 
                     "! Teach it to your monster through the " + 
                     "<a href='/learn_ability'>Ability Learning</a>" + " page!" 
          newAbilities.push(sentence)
        # else if response.type == 'monster'
        #   sentence = "You have earned " + response.reward +
        #              "! Learn more about it at the " +
        #              "<a href='/home'>Monster Equipping</a>" + " page!"
        #   newMonsters.push(sentence)
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
                share.style["z-index"] = "1000"
                share.className += " bounceIn animated"
                if response.type is "ability"
                  impact.innerHTML = response.impact
                  apcost.innerHTML = response.ap_cost
                  if response.modifier is "-"
                    sword.setAttribute("src","https://s3-us-west-2.amazonaws.com/monbattle/images/attack-25px.png")
                  else
                    sword.setAttribute("src","https://s3-us-west-2.amazonaws.com/monbattle/images/heal-25px.png")
                  stats.style["z-index"] = "100"
                  stats.style["opacity"] = "1"
                  stats.className += " bounceIn animated"
                message.innerHTML = response.message
                ability_icon.className += " bounceIn animated"
                description_box.className += " bounceIn animated"
              ), 840
          ), 600
        ), 1500
    $(document).on "click", ".back-to-store", ->
      document.getElementsByClassName("ability-won-description")[0].className = "ability-won-description"
      document.getElementsByClassName("ability-won-description")[0].style["opacity"] = "0"
      document.getElementsByClassName("store-overlay")[0].className = "store-overlay"
      document.getElementsByClassName("back-to-store")[0].className = "back-to-store"
      document.getElementsByClassName("back-to-store")[0].style["z-index"] = "-1"
      document.getElementsByClassName("share-roll-but")[0].className = "share-roll-but"
      document.getElementsByClassName("share-roll-but")[0].style["z-index"] = "-1"
      document.getElementsByClassName("roll-message")[0].style["opacity"] = "0"
      document.getElementsByClassName("ability-won-icon")[0].className = "ability-won-icon"
      document.getElementsByClassName("rarity-icon")[0].style["opacity"] = "0"
      document.getElementsByClassName("rarity-icon")[0].className = "rarity-icon"
      document.getElementsByClassName("roll-message")[0].innerHTML = ""
      document.getElementsByClassName("king-roll")[0].style["z-index"] = "1000"
      document.getElementsByClassName("queen-roll")[0].style["z-index"] = "1000"
      document.getElementsByClassName("mon-roll")[0].style["z-index"] = "1000"
      document.getElementsByClassName("ability-won-stats")[0].style["opacity"] = "0"
      document.getElementsByClassName("ability-won-stats")[0].style["z-index"] = "-1"
      document.getElementsByClassName("ability-won-stats")[0].className = "ability-won-stats"
  $(document).on "mouseover", ".showcase", ->
    $(".ability-detail").text latest_abilities[$(this).data("index")].description


