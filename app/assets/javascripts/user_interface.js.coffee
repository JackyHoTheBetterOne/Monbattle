window.setQuestBox = ->
  window.clearInterval(questTimer) if typeof questTimer isnt "undefined"
  window.questTimer = undefined
  count = $(".quest").length
  quest_box_height = 66.67 * count
  quest_outline_height = 69 * count
  $(".quests-info").css("height", quest_box_height.toString() + "px")
  $(".quests-outline").css("height", quest_outline_height.toString() + "px")
  window.questBox = []
  setTimeout (->
    console.log("Please")
    $('.quest-time').each ->
      seconds = parseInt($(this).text())
      questBox.push(seconds)
      index = (questBox.length-1).toString()
      $(this).attr("id", index)
  ), 450
  setTimeout (->
    window.questTimer = setInterval(countDown, 1000)
  ), 500
    


window.countDown = ->
  $(".quest-time").each ->
    seconds = undefined
    questBox[$(this).data("index")] -= 1  if questBox[$(this).data("index")] isnt 0
    questBox[$(this).attr("id")] -= 1
    seconds = questBox[$(this).attr("id")]
    $(this).text(moment().startOf("day").seconds(seconds).format("H:mm:ss"))

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
  setQuestBox()
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
      $(".quests-info, .quest-arrow, .quests-outline").css("opacity", "1").css("z-index", "100")
      $(".quest-arrow").css("z-index", "120")
    else 
      $(".quests-info, .quest-arrow, .quests-outline").css("opacity", "0").css("z-index", "-100")
  $(document).on "click", ".for-real, .close-quest, .quest-close-footer", ->
      $(".quests-info, .quest-arrow, .quests-outline").css("opacity", "0").css("z-index", "-100")
  $(document).on "click", ".fb-nav :not('.quest-show')", ->
    setTimeout (->
      setQuestBox()
    ), 100 





