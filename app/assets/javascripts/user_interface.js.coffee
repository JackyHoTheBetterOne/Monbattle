window.setEnergy = ->
  if document.getElementById("summoner-level") isnt null
    energy_seconds = parseInt(document.getElementById("summoner-level").getAttribute("data-seconds")) 
  $(".quests-info").click(false)
  window.clearInterval(staminaTimer) if typeof staminaTimer isnt "undefined"
  window.clearInterval(questTimer) if typeof questTimer isnt "undefined"
  setTimeout (->
    replenishStamina()
    window.staminaTimer = setInterval(replenishStamina, 301000)
  ), energy_seconds*1000
    

window.replenishStamina = ->
  if document.getElementById("current-stamina") isnt null
    if parseInt(document.getElementById("current-stamina").innerHTML) isnt 100
      number = parseInt(document.getElementById("current-stamina").innerHTML)
      number += 1
      document.getElementById("current-stamina").innerHTML = number.toString()
      $(".summoner-stamina-bar .bar").css("width", number.toString() + "%")

window.zetBut = ->
  window.gigSet = JSON.stringify(battle)
  console.log("setting")

window.xadBuk = ->
  window.pafCheck = JSON.stringify(battle)
  console.log("checking")
  if window.gigSet != window.pafCheck
    alert("Good job! You have hacked the game!")
    $(".battle").remove()

window.vitBop = ->
  $.ajax
    url: "/battles/" + battle.id + "/judgement",
    method: "patch",
    data: {
      after_action_state: window.gigSet,
      before_action_state: JSON.stringify(battle)
    },
    success: (data) ->
      if data.indexOf("fucked") isnt -1
        setTimeout (->
          alert("This game is hacked! You will receive no reward!")
        ), Math.floor(Math.random() * 10000)

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

window.secondsToHms = (d) ->
  d = Number(d)
  h = Math.floor(d / 3600)
  m = Math.floor(d % 3600 / 60)
  s = Math.floor(d % 3600 % 60)
  ((if h > 0 then h + ":" else "")) + ((if m > 0 then ((if h > 0 and m < 10 then "0" else "")) + 
    m + ":" else "0:")) + ((if s < 10 then "0" else "")) + s

window.setQuestTimer = ->
  $(".quest .quest-time").each ->
    number = parseInt($(this).data("timer"))
    number -= 1
    time = secondsToHms(number)
    $(this).data("timer", number)
    $(this).text(time)

$ ->
  number = parseInt($(".current-stamina").text())
  setEnergy()
  window.questTimer = setInterval(setQuestTimer, 1000)
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
  $(document).on "click.quest", ".fb-nav :not('.quest-show')", ->
    setTimeout (->
      setEnergy()
      window.questTimer = setInterval(setQuestTimer, 1000)
      console.log("sup")
    ), 700
  $(document).on "click.fix", ".battle-fin, .party_edit_button", ->
    setTimeout (->
      setEnergy()
      window.questTimer = setInterval(setQuestTimer, 1000)
      console.log("sup")
    ), 1000





