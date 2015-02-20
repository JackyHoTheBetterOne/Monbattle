window.zetBut = ->
  window.gigSet = JSON.parse(JSON.stringify(battle))
  console.log("shooting")


window.xadBuk = ->
  window.pafCheck = JSON.parse(JSON.stringify(battle))
  console.log("catching")
  if JSON.stringify(window.gigSet) != JSON.stringify(window.pafCheck)
    console.log(JSON.stringify(window.gigSet))
    console.log(JSON.stringify(window.pafCheck))
    alert("Good job! You have hacked the game!")
    $(".battle").remove()

window.vitBop = ->
  $.ajax
    url: "/battles/" + battle.id + "/showing",
    method: "patch",
    data: {
      after_action_state: window.gigSet,
      before_action_state: JSON.stringify(battle)
    },
    success: (data) ->
      if data.indexOf("hacked") isnt -1
        setTimeout (->
          alert("This game is hacked! You will receive no reward!")
        ), Math.floor(Math.random() * 5000)


window.setEnergy = ->
  if document.getElementById("summoner-level") isnt null
    energy_seconds = parseInt(document.getElementById("summoner-level").getAttribute("data-seconds")) 
  $(".quests-info").click(false)
  setTimeout (->
    replenishStamina()
    window.staminaTimer = setInterval(replenishStamina, 301000)
  ), energy_seconds*1000
  window.questTimer = setInterval(setQuestTimer, 1000)
  if window.location.href.indexOf("battles/new") isnt -1 and document.getElementsByClassName("sweet-home").length is 0
    index = document.getElementsByClassName("map-image").length-1
    region_name = document.getElementsByClassName("map-image")[index].getAttribute("data-region")
    document.getElementById(region_name).className += " current-region"
    index = document.getElementsByClassName("map-level").length-1
    area_name = document.getElementsByClassName("map-level")[0].getAttribute("id")
    document.getElementById(area_name).className += " current-area" 
  if window.location.href.indexOf("landing") isnt -1
    document.getElementsByClassName("news-entry")[0].className += " notice-selected"


window.setNewAbilityArray = ->
  setTimeout (->
    window.newAbilities.length = 0 if window.location.href.indexOf("learn_ability") isnt -1
  ), 2000
  setTimeout (->
    window.newAbilitiesLearned.length = 0
  ), 600
  setTimeout (->
    window.newMonsters.length = 0 if window.location.href.indexOf("home") isnt -1
  ), 2000

window.replenishStamina = ->
  if document.getElementById("current-stamina") isnt null
    number = parseInt(document.getElementById("current-stamina").innerHTML)
    max_num = parseInt(document.getElementById("max-stamina").innerHTML)
    if number isnt max_num 
      number += 1 
      $(".summoner-stamina-bar .bar").css("width", (100*number/max_num).toString() + "%")

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
  $(document).off "click.mon-tab-show"
  if $(".quest").length is 0 and document.getElementsByClassName("quests-outline").length isnt 0
    document.getElementsByClassName("quests-outline")[0].innerHTML =
      "<div class='quest'></div>" 
    document.getElementsByClassName("quests-info")[0].innerHTML = 
      "<div class='quest none'>Come back tomorrow for more daily quests!</div>"
    document.getElementsByClassName("none")[0].style["padding-top"] = "12px"
  if document.getElementById("turbolinks-overlay") isnt null
    $(document).on "page:before-change", ->
      document.getElementById("turbolinks-overlay").style["z-index"] = ("100000")
      document.getElementById("turbolinks-overlay").style.opacity = ("0.95")
    $(document).on "page:change", ->
      setTimeout (->
        document.getElementById("turbolinks-overlay").style.opacity = ("0")
        document.getElementById("turbolinks-overlay").style["z-index"] = ("-1")
      ), 100
  window.clearInterval(staminaTimer) if typeof staminaTimer isnt "undefined"
  window.clearInterval(questTimer) if typeof questTimer isnt "undefined"
  window.newAbilities = [] if typeof window.newAbilities is "undefined"
  window.newAbilitiesLearned = [] if typeof window.newAbilitiesLearned is "undefined"
  window.newMonsters = [] if typeof window.newMonsters is "undefined"
  number = parseInt($(".current-stamina").text())
  max_num = parseInt($(".max-stamina").text())
  setEnergy()
  setNewAbilityArray()
  $(".summoner-stamina-bar .bar").css("width", (100*number/max_num).toString() + "%")
  $(".donation-action").hide()
  $(document).on "keyup", ".donation", ->
    setDonationAmount()
    setDonationButton()
  $(document).on "click.donate", ".donation-click", (event) ->
    event.preventDefault()
    $(".stripe-button-el").trigger("click")
  $(document).on "click.mon-tab-show", ".mon-tab", (event) ->
    event.preventDefault()
    if $(".mon-dropdown").css("opacity") isnt "1"
      $(this).addClass("active-bar")
      $(".mon-dropdown").css({"z-index":"10000","opacity":"1"})
    else 
      $(this).removeClass("active-bar")
      $(".mon-dropdown").css({"z-index":"-10000000000","opacity":"0"})
  $(document).on "click.mon-tab-hide", ".for-real, .close-quest, .quest-close-footer, .quest-show", ->
      $(".mon-dropdown").css("opacity", "0").css("z-index", "-100")
      $(".mon-tab").removeClass("active-bar")
  $(document).on "click.quest-show", ".quest-show", (event) ->
    event.preventDefault()
    if $(".quest").length isnt 0
      if $(".quests-info").css("opacity") is "0"
        $(this).parent().addClass("active")
        $(".quests-info, .quest-arrow, .quests-outline").css("opacity", "1").css("z-index", "5000")
        $(".quest-arrow").css("z-index", "6000")
      else 
        $(this).parent().removeClass("active")
        $(".quests-info, .quest-arrow, .quests-outline").css("opacity", "0").css("z-index", "-100")
  $(document).on "click.quest-hide", ".for-real, .close-quest, .quest-close-footer, .mon-tab", ->
      $(".quests-info, .quest-arrow, .quests-outline").css("opacity", "0").css("z-index", "-100")
      $(".quest-show").parent().removeClass("active")





