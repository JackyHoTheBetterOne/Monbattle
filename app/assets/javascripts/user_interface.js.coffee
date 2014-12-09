window.setQuestBoxAndEnergy = ->
  if document.getElementById("summoner-level") isnt null
    energy_seconds = parseInt(document.getElementById("summoner-level").getAttribute("data-seconds")) 
  $(".quests-info").click(false)
  window.clearInterval(questTimer) if typeof questTimer isnt "undefined"
  window.clearInterval(staminaTimer) if typeof energyTimer isnt "undefined"
  window.questTimer = undefined
  count = $(".quest").length
  quest_box_height = 6 + 64 * count
  quest_outline_height = 10 + 65 * count
  $(".quests-info").css("height", quest_box_height.toString() + "px")
  $(".quests-outline").css("height", quest_outline_height.toString() + "px")
  count = 0
  setTimeout (->
    replenishStamina()
    window.staminaTimer = setInterval(replenishStamina, 301000)
  ), energy_seconds*1000 + 700
    

window.replenishStamina = ->
  if document.getElementById("current-stamina") isnt null
    if document.getElementById("current-stamina").innerHTML isnt "100"
      number = parseInt(document.getElementById("current-stamina").innerHTML)
      number += 1
      document.getElementById("current-stamina").innerHTML = number.toString()
      $(".summoner-stamina-bar .bar").css("width", (number/100*100).toString() + "%")

window.zetBut = ->
  $.ajax
    url: "/battles/" + battle.id + "/validation",
    method: "patch",
    data: {
      after_action_state: JSON.stringify(battle)
    }

window.xadBuk = ->
  $.ajax
    url: "/battles/" + battle.id + "/validation",
    method: "patch",
    data: {
      before_action_state: JSON.stringify(battle)
    },
    success: (data) ->
      if data.indexOf("fucked") isnt -1
        setTimeout (->
          alert("You motherfucker")
        ), 500

window.vitBop = ->
  $.ajax
    url: "/battles/" + battle.id + "/judgement",
    method: "patch",
    data: {
      before_action_state: JSON.stringify(battle)
    },
    success: (data) ->
      if data.indexOf("fucked") isnt -1
        setTimeout (->
          alert("You motherfucker")
        ), 500

# Math.floor(Math.random() * 12000)

setDonationAmount = ->
  window.money = $(".donation").val().replace(/,/g,'')*100

setDonationButton = ->
  $(".donation-action").html("    
    <script src='https://checkout.stripe.com/checkout.js' class='stripe-button hide'
    data-key='pk_test_qE72HFJsHUp6ldnoydHeWUTL'
    data-description= 'Donation for Monbattle'
    data-amount = #{money} ></script>
  ")

$ ->
  number = parseInt($(".current-stamina").text())
  $(".summoner-stamina-bar .bar").css("width", (number/100*100).toString() + "%")
  $(".donation-action").hide()
  $(document).on "keyup", ".donation", ->
    setDonationAmount()
    setDonationButton()
  $(document).on "click.donate", ".donation-click", (event) ->
    event.preventDefault()
    $(".stripe-button-el").trigger("click")
  $(document).on "click", ".quest-show", (event) ->
    event.preventDefault()
    if $(".quests-info").css("opacity") is "0"
      $(this).parent().addClass("active")
      $(".quests-info, .quest-arrow, .quests-outline").css("opacity", "1").css("z-index", "5000")
      $(".quest-arrow").css("z-index", "6000")
    else 
      $(this).parent().removeClass("active")
      $(".quests-info, .quest-arrow, .quests-outline").css("opacity", "0").css("z-index", "-100")
  $(document).on "click", ".for-real, .close-quest, .quest-close-footer", ->
      $(".quests-info, .quest-arrow, .quests-outline").css("opacity", "0").css("z-index", "-100")
      $(".quest-show").parent().removeClass("active")
  $(document).on "click.quest", ".fb-nav :not('.quest-show'), .battle-fin", ->
    setTimeout (->
      setQuestBoxAndEnergy()
    ), 250





