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
        ), Math.floor(Math.random() * 10000)


###########################################################################################################


################################################################################################### Battle interaction helpers
window.userTargetClick = ->
  $(document).on("mouseover.friendly", ".user.mon-slot .img", ->
    $(this).css("background", "rgba(255, 241, 118, .58)")
  ).on "mouseleave.friendly", ".user.mon-slot .img", ->
    $(this).css("background", "transparent")


window.offUserTargetClick = ->
  $(document).off "mouseover.friendly", ".user.mon-slot .img"
  $(document).off "mouseleave.friendly", ".user.mon-slot .img"

window.endCutScene = ->
  $(document).off "click.cutscene", "#overlay"
  $(".cutscene").css("opacity", "0")
  $(".next-scene").css("opacity", "0")

window.nextSceneInitial = ->
  document.getElementById('overlay').style.pointerEvents = 'none'
  setTimeout (->
    $(".next-scene").css("opacity", "0.9")
    document.getElementById('overlay').style.pointerEvents = 'auto'
  ), 1000

window.nextScene = ->
  if document.getElementById('overlay') isnt null
    document.getElementById('overlay').style.pointerEvents = 'none' 
  $(".cutscene").css("opacity", "0")
  $(".next-scene").css("opacity", "0")
  setTimeout (->
    $(".cutscene").attr("src", new_scene)
  ), 300
  setTimeout (->
    $(".cutscene").css("opacity", "1")
  ), 1000
  setTimeout (->
    $(".next-scene").css("opacity", "0.9")
    if document.getElementById('overlay') isnt null
      document.getElementById('overlay').style.pointerEvents = 'auto'
  ), 2000

window.mouseOverMon = ->
  if $(this).css("opacity") isnt "0"
    $(this).prev().css "visibility", "visible"
    $(this).addClass("controlling")
    $(this).prev().css "opacity", "1"
    mon = $(this).closest(".mon").data("index")
    team = $(this).closest(".mon-slot").data("team")
    window.currentMon = $(this)
    window.targets = [
      team
      mon
    ]

window.mouseLeaveMon = ->
  $(".user .monBut").css({"opacity":"0", "visibility":"hidden"})
  $(".user .img").removeClass("controlling")

window.turnOnCommandA = ->
  $(document).on "mouseleave.command", ".user.mon-slot .mon", mouseLeaveMon
  $(document).on "mouseover.command, mousemove.command", ".user.mon-slot .img", mouseOverMon

window.turnOffCommandA = ->
  $(document).off "mouseleave.command", ".user.mon-slot .mon", mouseLeaveMon
  $(document).off "mouseover.command, mousemove.command", ".user.mon-slot .img", mouseOverMon

window.turnOff = (name, team) ->
  $(document).off name, team + ".mon-slot .img"

window.disable = (button) ->
  button.attr("disabled", "true")
  button.css("opacity", 0)

window.enable = (button) ->
  button.removeAttr("disabled")
  button.css("opacity", 1)

window.toggleImg = ->
  $(".user .img").each ->
    if $(this).attr("disabled") is "disabled"
      $(this).removeAttr("disabled")
    else
      $(this).attr("disabled", "true")

window.flashEndButton = ->
  window.buttonArray = []
  $(".end-turn").prop("disabled", false)
  $(".monBut button").each ->
    if $(this).parent().parent().children(".img").css("opacity") isnt "0" && $(this).attr("disabled") isnt "disabled"
      buttonArray.push $(this)
  if buttonArray.every(noApLeft) || buttonArray.every(nothingToDo)
    zetBut()
    setTimeout (->
      $(".end-turn").trigger("click")
      return
    ), 1000
    return

window.toggleEnemyClick = ->
  $(".enemy .img").each ->
    if $(this).attr("disabled") is "disabled"
      $(this).prop("disabled", false)
    else
      $(this).prop("disabled", true)




######################################################################################################## Battle display helpers
window.callAbilityImg = ->
  battle.players[targets[0]].mons[targets[1]].abilities[targets[2]].img

window.barChange = (current, max) ->
  "width": (current/max*100).toString() + "%"

window.apNum = ".ap .ap-number"

window.apBar = ".ap-meter .bar"

window.apInfo = (maxAP) ->
  "AP:" + "   " + maxAP + " / " + maxAP

window.apAfterUse = (current, max) ->
  "AP:" + "   " + current + " / " + max

window.apChange = ->
  $(apNum).text apAfterUse(battle.players[0].ap , battle.maxAP)
  $(apBar).css barChange(battle.players[0].ap, battle.maxAP)

window.hpChange = (side, index) ->
  "." + side + " " + ".mon" + index + " " + ".current-hp"

window.maxHpChange = (side, index) ->
  "." + side + " " + ".mon" + index + " " + ".max-hp"

window.hpBarChange = (side, index) ->
  "." + side + " " + ".mon" + index + " " + ".hp .bar"


window.hpChangeBattle = ->
  n = playerMonNum
  i = 0
  while i < n
    $(hpBarChange("0", i)).css barChange(battle.players[0].mons[i].hp, battle.players[0].mons[i].max_hp) 
    $(maxHpChange("0", i)).text " " + "/" + " " + battle.players[0].mons[i].max_hp
    $(hpChange("0", i)).text battle.players[0].mons[i].hp
    i++
  n = pcMonNum
  i = 0
  while i < n 
    $(hpBarChange("1", i)).css barChange(battle.players[1].mons[i].hp, battle.players[1].mons[i].max_hp)
    $(maxHpChange("1", i)).text " " + "/" + " " + battle.players[1].mons[i].max_hp
    $(hpChange("1", i)).text battle.players[1].mons[i].hp
    i++


window.damageBoxAnime= (team, target, damage, color) ->
  $("." + team + " " + ".mon" + target + " " + "p.dam").text(damage).animate({"color":color, "font-weight":"bold"}, 1).
  fadeIn(1).animate({"top":"-=50px", "z-index":"+=10000"}, 200).effect("bounce", {times: 10}).fadeOut().
  animate
    "top":"+=50px"
    "z-index":"-=10000"
    , 5, ->
      setTimeout (->
        if battle.players[0].mons.every(isTeamDead) is true or battle.players[1].mons.every(isTeamDead) is true
            turnOffCommandA()
            $(".img, .ability-img, .single-ability-img").promise().done ->
              $(".img, .ability-img, .single-ability-img, p.dam, .effect-box").promise().done ->
                setTimeout (->
                  $("p.dam").promise().done ->
                    outcome()
                ), 350
      ), 350

window.showDamageSingle = ->
  damageBoxAnime(enemyHurt.team, enemyHurt.index, ability.modifier + window["change" + enemyHurt.index], "rgba(255, 0, 0)")

window.showHealSingle = ->
  damageBoxAnime(allyHealed.team, allyHealed.index, ability.modifier + window["change" + allyHealed.index], "rgba(50,205,50)")

window.showDamageTeam = (index) ->
  i = undefined
  n = undefined
  n = battle.players[index].mons.length
  i = 0
  while i < n
    if parseInt($("." + index + " " + ".mon" + i + " " + ".current-hp").text()) > 0
      damageBoxAnime(index, i, ability.modifier + window["change" + i], "rgba(255, 0, 0)")
    i++

window.showHealTeam = (index) ->
  i = undefined
  n = undefined
  n = battle.players[index].mons.length
  i = 0
  while i < n
    console.log(battle.players[index].mons[i])
    if battle.players[index].mons[i].hp > 0
      damageBoxAnime(index, i, ability.modifier + window["change" + i], "rgba(50, 205, 50)")
    i++

window.outcome = ->
  if battle.players[0].mons.every(isTeamDead) is true
    $.ajax
      url: "/battles/" + battle.id + "/loss"
      method: "get"
      success: (response) ->
        $(".message").html(response)
    vitBop()
    toggleImg()
    document.getElementById('battle').style.pointerEvents = 'none'
    setTimeout (->
      $(".end-battle-but").addClass("battle-fin")
      ), 250
    $("#overlay").fadeIn 1000, ->
      setTimeout (->
        $(".next-scene").remove()
        $(".message").addClass("animated bounceIn")
      ), 250
    setTimeout (->
      $.ajax
        url: "/battles/" + battle.id
        method: "patch"
        data: {
          "victor": battle.players[1].username,
          "loser": battle.players[0].username,
          "round_taken": parseInt(battle.round)
        }
    ), 1000
  else if battle.players[1].mons.every(isTeamDead) is true
    $.ajax
      url: "/battles/" + battle.id + "/win"
      method: "get"
      success: (response) ->
        $(".message").html(response)
        if $(".ability-earned").text() isnt ""
          sentence = "You have gained " + $(".ability-earned").text().replace(/\s+/g, '-') + 
                     "! It can be equipped to monsters with the following class names: " + 
                     $(".ability-earned").data("class") + ", on slot " + $(".ability-earned").data("slot") +
                     ". Go to the team editing page and find it by searching for the class name." 
          newAbilities.push(sentence)
    vitBop()
    toggleImg()
    document.getElementById('battle').style.pointerEvents = 'none'
    $(".message").css("opacity", "0")
    setTimeout (->
      $.ajax
        url: "/battles/" + battle.id
        method: "patch"
        data: {
          "victor": battle.players[0].username,
          "loser": battle.players[1].username,
          "round_taken": parseInt(battle.round)
        }
    ), 1000
    $(document).on "click.cutscene", "#overlay", ->
      if $(".cutscene").attr("src") is battle.end_cut_scenes[battle.end_cut_scenes.length-1]
        $(".cutscene").hide(500)
        endCutScene()
        setTimeout (->
          $(".next-scene").remove()
          $(".message").addClass("animated bounceIn")
          $(".end-battle-but").addClass("battle-fin")
        ), 500
      else 
        new_index = battle.end_cut_scenes.indexOf($(".cutscene").attr("src")) + 1
        window.new_scene = battle.end_cut_scenes[new_index]
        nextScene()
    if battle.end_cut_scenes.length isnt 0
      $(".cutscene").attr("src", battle.end_cut_scenes[0])
      $(".cutscene").css("opacity", "1")
      $("#overlay").fadeIn(1000)
      nextSceneInitial()
    else 
      $(".cutscene, .next-scene").css("opacity", "0")
      $(".message").promise().done ->
        $(".end-battle-but").addClass("battle-fin")
        $("#overlay").fadeIn(1000)
        setTimeout (->
          $(".next-scene").remove()
          $(".message").addClass("animated bounceIn")
        ), 1250
      $(document).off "click.cutscene", "#overlay"
window.checkApAvailbility = ->
  $(".monBut button").each ->
    disable($(this)) if $(this).data("apcost") > battle.players[0].ap

window.checkMonHealthAfterEffect = ->
  fixHp()
  i = 0
  n = playerMonNum
  while i < n
    battle.players[0].mons[i].isAlive()
    i++
  i = 0 
  n = pcMonNum
  while i < n
    battle.players[1].mons[i].isAlive()
    i++

window.addEffectIcon = (monster, effect) -> 
  e = Object.create(effect)
  e.target = battle.players[effect.teamDex].mons[effect.monDex].name if effect.targeta is "taunt"
  e.enemyDex = monster.team
  e.enemyMonDex = monster.index
  e.end = effect.duration + battle.round
  effectBin.push(e)
  index = effectBin.indexOf(e)
  $("<img src = '#{effect.img}' class = 'effect #{monster.name} #{effect.name} #{effect.targeta}' id='#{index}' >").
    prependTo("." + monster.team + " " + ".mon" + monster.index + " " + ".effect-box").addClass("tada animated")
  setTimeout (->
    $(".tada.animated").removeClass("tada animated")
  ), 1000


window.removeEffectIcon = (monster, effect) ->
  $("." + monster.team + " " + ".mon" + monster.index + " " + "." + effect.targeta).fadeOut 400, ->
    $(this).trigger("mouseleave").remove()

window.massRemoveEffectIcon = (effect) ->
  $("." + effect.targeta).fadeOut 400, ->
    $(this).trigger("mouseleave").remove()


window.battleStartDisplay = (time) ->
  $(".message").css("opacity", "0")
  setTimeout (->
    $("#overlay").fadeOut 500, ->
      $(".battle-message").show(500).effect("highlight", 500).fadeOut(300)
      return
    ), time
  setTimeout (->
    $("#battle-tutorial").joyride({'tipLocation': 'top'})
    $("#battle-tutorial").joyride({})
    toggleImg()
    $(".user .img").each ->
      $(this).effect("bounce", {distance: 80, times: 5}, 1500)
  ), (time + 1500)
