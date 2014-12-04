window.setQuestBox = ->
  count = $(".quest").length
  quest_box_height = 66.67 * count
  quest_outline_height = 69 * count
  console.log(quest_box_height.toString() + "px")
  console.log(quest_outline_height.toString() + "px")
  $(".quests-info").css("height", quest_box_height.toString() + "px")
  $(".quests-outline").css("height", quest_outline_height.toString() + "px")

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
      $(".quests-info, .quest-arrow, .quests-outline").css("opacity", "1")
    else 
      $(".quests-info, .quest-arrow, .quests-outline").css("opacity", "0")
  $(document).on "click", ".for-real", ->
      $(".quests-info, .quest-arrow, .quests-outline").css("opacity", "0")
  $(document).on "click", ".fb-nav :not('.quest-show')", ->
    setTimeout (->
      setQuestBox()
      ), 250    








