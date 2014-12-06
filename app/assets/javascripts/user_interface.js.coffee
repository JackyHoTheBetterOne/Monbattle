window.setQuestBox = ->
  $(".quests-info").click(false)
  window.clearInterval(questTimer) if typeof questTimer isnt "undefined"
  window.questTimer = undefined
  count = $(".quest").length
  quest_box_height = 6 + 64 * count
  quest_outline_height = 10 + 65 * count
  $(".quests-info").css("height", quest_box_height.toString() + "px")
  $(".quests-outline").css("height", quest_outline_height.toString() + "px")
  count = 0
  $('.quest-time').each ->
    $(this).attr("id", count)
    console.log(count)
    count += 1
  if !isNaN(parseInt($(".quest-time").last().text()))
    window.questBox = []
    setTimeout (->
      $('.quest-time').each ->
        seconds = parseInt($(this).text())
        questBox.push(seconds)
        index = (questBox.length-1).toString()
        $(this).attr("id", index)
      console.log(questBox)
    ), 400
  setTimeout (->
    window.questTimer = setInterval(countDown, 1000)
  ), 700
  $(document).off "click", ".quests-info"
    


window.countDown = ->
  $(".quest-time").each ->
    seconds = undefined
    questBox[$(this).attr("id")] -= 1  if questBox[$(this).data("id")] isnt 0
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
  setTimeout (->
    setQuestBox()
  ), 200
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
      $(".quests-info, .quest-arrow, .quests-outline").css("opacity", "1").css("z-index", "100")
      $(".quest-arrow").css("z-index", "120")
    else 
      $(this).parent().removeClass("active")
      $(".quests-info, .quest-arrow, .quests-outline").css("opacity", "0").css("z-index", "-100")
  $(document).on "click", ".for-real, .close-quest, .quest-close-footer", ->
      $(".quests-info, .quest-arrow, .quests-outline").css("opacity", "0").css("z-index", "-100")
      $(".quest-show").parent().removeClass("active")
  $(document).on "click.quest", ".fb-nav :not('.quest-show'), .battle-fin", ->
    setTimeout (->
      setQuestBox()
    ), 500





