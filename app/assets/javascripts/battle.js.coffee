# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

######################################################################################################## Monster logics
window.fixEvolMon = (monster, player) ->
  monster.physical_resistance = 0
  monster.special_resistance = 0
  monster.fucking_up = []
  monster.fucked_up = []
  monster.taunted = {}
  monster.taunted.target = undefined
  monster.team = battle.players.indexOf(player)
  monster.index = player.mons.indexOf(monster)
  monster.isAlive = ->
    if @hp <= 0
      return false
    else
      return true
    return
  monster.useAbility = (abilityIndex, abilityTargets) ->
    ability = @abilities[abilityIndex]
    ability.use(abilityTargets)
######################################################################################################## Ability logics
  $(monster.abilities).each ->
    ability = @
    ability.use = (abilitytargets) ->
      a = this
      i = 0
      while i < abilitytargets.length
        monTarget = abilitytargets[i]
        if a.targeta is "cleanseally" or a.targeta is "aoecleanse"
          ii = 0 
          iii = 0
          while ii < monTarget.fucking_up.length
            e = monTarget.fucking_up[ii]
            monTarget.fucking_up.splice(ii, 1)  if e.impact.indexOf("-") isnt -1
            removeEffectIcon(monTarget, e) 
            ii++
          while iii < monTarget.fucked_up.length
            e = monTarget.fucked_up[iii]
            monTarget.fucked_up.splice(iii, 1) if e.restore.indexOf("+") isnt -1
            removeEffectIcon(monTarget, e)
            iii++
          if a.modifier isnt ""
            window.change = a.change
            monTarget[a.stat] = eval(monTarget[a.stat] + a.modifier + change)
        else if a.modifier is "-" and a.targeta is "attack"
          window.change = eval(a.change - monTarget["physical_resistance"])
          monTarget[a.stat] = eval(monTarget[a.stat] + a.modifier + change)
        else if a.modifier is "-" and (a.targeta is "targetenemy" or a.targeta is "aoeenemy") 
          window.change = eval(a.change - monTarget["special_resistance"])
          monTarget[a.stat] = eval(monTarget[a.stat] + a.modifier + change)
        else
          window.change = a.change 
          monTarget[a.stat] = eval(monTarget[a.stat] + a.modifier + change)
          monTarget.isAlive() if typeof monTarget.isAlive isnt "undefined"
        i++
      if ability.effects.length isnt 0
        i = 0
        while i < ability.effects.length
          effect = a.effects[i]
          switch effect.targeta
            when "poison-health", "poison-resistance", "taunt", "timed-resistance-buff", "timed-resistance-debuff"
              effect.activate abilitytargets
            when "timed-attack-buff"
              i = 0 
              n = abilitytargets.length
              while i < n 
                window.teamAttackAbilities = []
                teamAttackAbilities.push(abilitytargets[i].abilities[0])
                i++
              targets = teamAttackAbilities
              effect.activate targets
            when "self"
              effect.activate [monster]
            when "selfbuffattack"
              effect.activate [monster.abilities[0]]
            when "tworandomfoes"
              effectTargets = []
              findAliveEnemies()
              effectTargets.push liveFoes[0]
              effectTargets.push liveFoes[1] if typeof liveFoes[1] isnt "undefined"
              effect.activate effectTargets
            when "onerandomfoe"
              effectTargets = []
              findAliveEnemies()
              effectTargets.push liveFoes[0]
              effect.activate effectTargets
            when "tworandommons"
              findAliveEnemies()
              findAliveFriends()
              findAliveMons()
              effectTargets = []
              effectTargets.push liveMons[0]
              effectTargets.push liveMons[1] if typeof liveMons[1] isnt "undefined"
              effect.activate effectTargets
            when "foebuffattack"
              effectTargets = []
              i = 0
              while i < abilitytargets.length
                index = getRandom([0,1,2,3])
                effectTargets.push abilitytargets[i].abilities[index]
                i++
              effect.activate effectTargets
            when "tworandomallies"
              effectTargets = []
              findAliveFriends()
              effectTargets.push liveFriends[0]
              effectTargets.push liveFriends[1] if typeof liveFriends[1] isnt "undefined"
              effect.activate effectTargets
          i++
      return
######################################################################################################### Effect logics
    $(ability.effects).each ->
      @name = @name.replace(/\s+/g, '')
      @activate = (effectTargets) ->
        e = this
        i = 0
        if e.targeta.indexOf("taunt") isnt -1
          while i < effectTargets.length
            monTarget = effectTargets[i]
            if monTarget.taunted.end is undefined
              addEffectIcon(monTarget, e)
            else 
              removeEffectIcon(monTarget, e)
              addEffectIcon(monTarget, e)
            monTarget.taunted.name = e.name
            monTarget.taunted.target = battle.players[0].indexOf(monster)
            monTarget.taunted.end = battle.round + e.duration
            i++
        else if e.targeta.indexOf("poison") isnt -1
          while i < effectTargets.length
            monTarget = effectTargets[i]
            monTarget[e.stat] = eval(monTarget[e.stat] + e.modifier + e.change)
            checkMin()
            checkMax()
            monTarget.isAlive() if typeof monTarget.isAlive isnt "undefined"
            findObjectInArray(monTarget.fucking_up, "name", e.name)
            if usefulArray.length is 0 and monTarget.isAlive()
              status = {}
              status["name"] = e.name
              status["stat"] = e.stat
              status["impact"] = e.modifier + e.change
              status["end"] = battle.round + e.duration
              monTarget.fucking_up.push(status)
              addEffectIcon(monTarget, e)
            else if monTarget.isAlive()
              old_effect = usefulArray[0]
              removeEffectIcon(monTarget, old_effect)
              addEffectIcon(monTarget, e)
              old_effect.name = e.name
              old_effect.impact = e.modifier + e.change
              old_effect.end = battle.round + e.duration
            i++
        else if e.targeta.indexOf("timed") isnt -1
          while i < effectTargets.length
            monTarget = effectTargets[i]
            findObjectInArray(monTarget.fucked_up, "name", e.name)
            if usefulArray.length is 0
              monTarget[e.stat] = eval(monTarget[e.stat] + e.modifier + e.change)
              status = {}
              status["name"] = e.name
              status["stat"] = e.stat
              status["restore"] = e.restore
              status["end"] = battle.round + e.duration
              monTarget.fucked_up.push(status)
              addEffectIcon(monTarget, e)
            else 
              old_effect = usefulArray[0]
              monTarget[old_effect.stat] = eval(monTarget[old_effect.stat] + e.restore)
              monTarget[e.stat] = eval(monTarget[e.stat] + e.modifier + e.change)
              usefulArray[0]["restore"] = e.restore
              usefulArray[0]["end"] = battle.round + e.duration
              removeEffectIcon(monTarget, e)
              addEffectIcon(monTarget, e)
            i++
        else 
          while i < effectTargets.length
            monTarget = effectTargets[i]
            addEffectIcon(monTarget, e)
            setTimeout (->
              removeEffectIcon(monTarget, e)
              ), 100
            monTarget[e.stat] = eval(monTarget[e.stat] + e.modifier + e.change)
            checkMin()
            checkMax()
            monTarget.isAlive() if typeof monTarget.isAlive isnt "undefined"
            i++



################################################################################################################ Logic helpers
window.findObjectInArray = (array, field, value) ->
  window.usefulArray = []
  i = 0 
  while i < array.length             
    if array[i][field].indexOf(value) isnt -1
      usefulArray.push(array[i])
    i++

window.isTeamDead = (monster, index, array) ->
  monster.isAlive() is false
window.isTurnOver = (object, index, array) ->
  object.turn is false
window.noApLeft = (object, index, array) ->
  $(object).data("apcost") > battle.players[0].ap
window.nothingToDo = (object, index, array) ->
  $(object).css("opacity") is "0"

window.setAll = (array, attr, value) ->
  n = array.length
  i = 0
  while i < n
    array[i][attr] = value
    i++
  return

window.checkMax = ->
  n = playerMonNum
  i = 0
  while i < n
    mon = battle.players[0].mons[i]
    battle.players[0].mons[i].hp = mon.max_hp if mon.hp > mon.max_hp
    i++
  return

window.checkMin = ->
  n = playerMonNum
  i = 0
  while i < n
    mon = battle.players[0].mons[i]
    battle.players[0].mons[i].max_hp = 0 if mon.hp is 0
    i++
  return

window.action = ->
  battle.monAbility(targets[0], targets[1], targets[2], targets[3])
window.multipleAction = ->
  battle.monAbility(targets[0], targets[1], targets[2])
window.userMon = (index) ->
  $(".user .mon" + index + " " + ".img")

window.numOfDeadFoe = ->
  num = 0
  n = pcMonNum
  i = 0
  while i < n
    if battle.players[1].mons[i].isAlive() is false
      num += 1
    i++
  return num
window.checkEnemyDeath = (index) ->
  return !battle.players[1].mons[index].isAlive()

window.shuffle = (array) ->
  i = array.length - 1
  while i > 0
    j = Math.floor(Math.random() * (i + 1))
    temp = array[i]
    array[i] = array[j]
    array[j] = temp
    i--
  array

window.findAliveEnemies =  ->
  window.liveFoes = []
  n = playerMonNum
  i = 0
  while i < n
    if battle.players[0].enemies[i].isAlive() is true
      liveFoes.push battle.players[0].enemies[i]
    i++
  shuffle(liveFoes)

window.findAliveFriends = ->
  window.liveFriends = []
  n = playerMonNum
  i = 0
  while i < n
    if battle.players[0].mons[i].isAlive() is true
      liveFriends.push battle.players[0].mons[i]
    i++
  shuffle(liveFriends)

window.findAliveMons = ->
  window.liveMons = liveFriends.concat liveFoes
  shuffle(window.liveMons)

window.randomNumRange = (max, min)->
  Math.floor(Math.random() * (max - min) + min)


#########################################################################################################  AI timer
window.enemyTimer = ->
  window.timer1 = 0
######################################################################
  if checkEnemyDeath(1) is true
    window.timer3 = 0
  else
    window.timer3 = 2500
######################################################################
  if checkEnemyDeath(1) is true && checkEnemyDeath(3) is true
    window.timer2 = 0
  else if checkEnemyDeath(1) is true || checkEnemyDeath(3) is true
    window.timer2 = 2500
  else
    window.timer2 = 5000
######################################################################
  if checkEnemyDeath(1) && checkEnemyDeath(3) && checkEnemyDeath(2)
    window.timer0 = 0
  else if ( ( checkEnemyDeath(1) && checkEnemyDeath(2) ) || ( checkEnemyDeath(1) && checkEnemyDeath(3) ) ) ||
          ( checkEnemyDeath(2) && checkEnemyDeath(3) )
    window.timer0 = 2500
  else if ( checkEnemyDeath(1) || checkEnemyDeath(2) ) || checkEnemyDeath(3)
    window.timer0 = 5000
  else
    window.timer0 = 7500
######################################################################
  switch numOfDeadFoe()
    when 0
      window.timerRound = 10000
    when 1
      window.timerRound = 7500
    when 2
      window.timerRound = 5000
    when 3
      window.timerRound = 2500



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
  $(apBar).animate barChange(battle.players[0].ap, battle.maxAP), 200

window.hpChange = (side, index) ->
  "." + side + ".info" + " " + ".mon" + index + " " + ".current-hp"

window.hpBarChange = (side, index) ->
  "." + side + " " + ".mon" + index + " " + ".hp .bar"

window.hpChangeBattle = ->
  n = playerMonNum
  i = 0
  while i < n
    battle.players[0].mons[i].hp = (if (battle.players[0].mons[i].hp < 0) then 0 else battle.players[0].mons[i].hp)
    $(hpBarChange("0", i)).css barChange(battle.players[0].mons[i].hp, battle.players[0].mons[i].max_hp) if battle.
                    players[0].mons[i].hp.toString() != $(".user.info" + " " + ".mon" + i + " " + ".current-hp").text()
    $(hpChange("0", i)).text battle.players[0].mons[i].hp
    i++
  n = pcMonNum
  i = 0
  while i < n 
    battle.players[1].mons[i].hp = (if (battle.players[1].mons[i].hp < 0) then 0 else battle.players[1].mons[i].hp)
    $(hpBarChange("1", i)).css barChange(battle.players[1].mons[i].hp, battle.players[1].mons[i].max_hp) if battle.
                    players[1].mons[i].hp.toString() != $(".user.info" + " " + ".mon" + i + " " + ".current-hp").text()
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
        $(".img, .ability-img, .single-ability-img").promise().done ->
          $(".img, .ability-img, .single-ability-img, p.dam").promise().done ->
            setTimeout (->
              $("p.dam").promise().done ->
                outcome()
            ), 100
      ), 100

window.showDamageSingle = ->
  damageBoxAnime(enemyHurt.team, enemyHurt.index, ability.modifier + change, "rgba(255, 0, 0)")

window.showHealSingle = ->
  damageBoxAnime(allyHealed.team, allyHealed.index, ability.modifier + change, "rgba(50,205,50)")

window.showDamageTeam = (index) ->
  i = undefined
  n = undefined
  n = battle.players[index].mons.length
  i = 0
  while i < n
    if parseInt($("." + index + " " + ".mon" + i + " " + ".current-hp").text()) > 0
      damageBoxAnime(index, i, ability.modifier + change, "rgba(255, 0, 0)")
    i++

window.showHealTeam = (index) ->
  i = undefined
  n = undefined
  n = battle.players[index].length
  i = 0
  while i < n
    if battle.players[index].mons[i].hp > 0
      damageBoxAnime(index, i, ability.modifier + change, "rgba(50, 205, 50)")
    i++

window.outcome = ->
  if battle.players[0].mons.every(isTeamDead) is true
    $(".message").text("You lost, but here's " + battle.reward*0.1 + " MP because we pity you. Try harder next time!").
      append("<br/><br/><a href='/battles/new' class='btn btn-danger'>Avenge your time</a>")
    $("#overlay").fadeIn(1000)
    $.ajax
      url: "/battles/" + battle.id
      method: "patch"
      data: {
        "victor": battle.players[1].username,
        "loser": battle.players[0].username
      }
  else if battle.players[1].mons.every(isTeamDead) is true
    $(".message").text("You won" + " " + battle.reward + " " + "MP! " + "Go kill more monsters!").
      append("<br/><br/><a href='/battles/new' class='btn btn-success'>Continue your journey</a>")
    if battle.end_cutscene is "none"
      $("#overlay").fadeIn(1000)
      $("body").on "click", ->
        $("#overlay").fadeOut(500)
        disable($(".end-turn"))
    else
      $(".message").hide()
      $(".cutscene").attr("src", battle.end_cutscene).css("visibility", "visible")
      $("#overlay").fadeIn(1000)
      setTimeout (->
        $(".cutscene").fadeOut 500, ->
          $(".message").fadeIn 500
        ), 4000
      $.ajax
        url: "/battles/" + battle.id
        method: "patch"
        data: {
          "victor": battle.players[0].username,
          "loser": battle.players[1].username
        }
  return

window.checkApAvailbility = ->
  $(".monBut button").each ->
    disable($(this)) if $(this).data("apcost") > battle.players[0].ap

window.checkMonHealthAfterEffect = ->
  i = 0
  n = playerMonNum
  while i < n
    $(".0 .mon" + i + " " + ".img").fadeOut(500) if battle.players[0].mons[i].hp <= 0
    i++
  i = 0 
  n = pcMonNum
  while i < n
    $(".1 .mon" + i + " " + ".img").fadeOut(500) if battle.players[1].mons[i].hp <= 0
    i++

window.addEffectIcon = (monster, effect) -> 
  effectBin.push(effect)
  index = effectBin.indexOf(effect)
  $("<img src = '#{effect.img}' class = 'effect #{monster.name} #{effect.name} #{effect.targeta}' id='#{index}' >").
    prependTo("." + monster.team + " " + ".mon" + monster.index + " " + ".effect-box")


window.removeEffectIcon = (monster, effect) ->
  $("." + monster.team + " " + ".mon" + monster.index + " " + "." + effect.name).fadeOut(300).remove()



################################################################################################### Display function-calling helpers
window.singleTargetAbilityAfterClickDisplay = ->
  turnOff("click.boom", ".enemy")
  turnOff("click.help", ".user")
  $(document).off "click.cancel", ".cancel"
  $(".user .img").removeClass("controlling")
  $(".battle-guide").hide()

window.singleTargetAbilityAfterActionDisplay = ->
  apChange()
  hpChangeBattle()
  checkMonHealthAfterEffect()
  toggleImg()
  flashEndButton()



############################################################################################### Battle display variable helpers
window.singleTargetAbilityDisplayVariable = ->
  window.enemyHurt = battle.players[targets[0]].enemies[targets[3]]
  window.monsterUsed = battle.players[targets[0]].mons[targets[1]]
  window.ability = battle.players[targets[0]].mons[targets[1]].abilities[targets[2]]

window.singleHealTargetAbilityDisplayVariable = ->
  window.allyHealed = battle.players[targets[0]].mons[targets[3]]
  window.monsterUsed = battle.players[targets[0]].mons[targets[1]]
  window.ability = battle.players[targets[0]].mons[targets[1]].abilities[targets[2]]

window.multipleTargetAbilityDisplayVariable = ->
  window.ability = battle.players[targets[0]].mons[targets[1]].abilities[targets[2]]
  window.monsterUsed = battle.players[targets[0]].mons[targets[1]]



################################################################################################### Battle interaction helpers
window.mouseOverMon = ->
  $(this).addClass("controlling")
  $(this).prev().css "visibility", "visible"
  mon = $(this).closest(".mon").data("index")
  team = $(this).closest(".mon-slot").data("team")
  window.currentMon = $(this)
  window.targets = [
    team
    mon
  ]
  return

window.mouseLeaveMon = ->
  $(".user .monBut").css "visibility","hidden"
  $(".user .img").removeClass("controlling")

window.turnOnCommandA = ->
  $(document).on "mouseleave.command", ".user.mon-slot .mon", mouseLeaveMon
  $(document).on "mouseover.command", ".user.mon-slot .img", mouseOverMon

window.turnOffCommandA = ->
  $(document).off "mouseleave.command", ".user.mon-slot .mon", mouseLeaveMon
  $(document).off "mouseover.command", ".user.mon-slot .img", mouseOverMon

window.turnOnCommand = (funk) ->
  $(document).on "click.command", ".user.mon-slot .img", funk

window.turnOffCommand = (funk) ->
  $(document).off "click.command", ".user.mon-slot .img", funk

window.turnOff = (name, team) ->
  $(document).off name, team + ".mon-slot .img"

window.disable = (button) ->
  button.attr("disabled", "true")
  button.animate({"background-color":"rgba(192, 192, 192, 0)", "border-color":"black"
                , "opacity":"0"})

window.enable = (button) ->
  button.removeAttr("disabled")
  button.animate({"background-color":"rgba(10, 170, 230, 0.80)", "border-color":"black"
                , "opacity":"1"})

window.toggleImg = ->
  $(".user .img").each ->
    if $(this).attr("disabled") is "disabled"
      $(this).removeAttr("disabled")
    else
      $(this).attr("disabled", "true")

window.flashEndButton = ->
  buttonArray = []
  $(".end-turn").prop("disabled", false)
  $(".monBut button").each ->
    if $(this).parent().parent().children(".img").css("display") isnt "none" && $(this).attr("disabled") isnt "disabled"
      buttonArray.push $(this)
  if buttonArray.every(noApLeft) || buttonArray.every(nothingToDo)
    setTimeout (->
      $(".end-turn").trigger("click")
      return
    ), 800
    return

window.toggleEnemyClick = ->
  $(".enemy .img").each ->
    if $(this).attr("disabled") is "disabled"
      $(this).prop("disabled", false)
    else
      $(this).prop("disabled", true)


###################################################################################################### Effect helpers
window.roundEffectHappening = (team) ->
  $("." + team + " " + ".effect-box").effect("pulsate",{times: 3}, 300)
  i = 0
  n = battle.players[team].mons.length
  while i < n 
    mon = battle.players[team].mons[i]
    if mon.taunted.target isnt undefined and battle.round is monster.taunted.end
      $( "." + team + " " + "." + mon.index + " " + "." + mon.taunted.name).fadeOut(300).remove()
      mon.taunted.target = undefined
    if mon.fucking_up.length isnt 0 and mon.isAlive() 
      ii = 0 
      nn = mon.fucking_up.length
      while ii < nn
        e = mon.fucking_up[ii]
        if battle.round is e.end
          $( "." + team + " " + "." + mon.index + " " + "." + mon.fucking_up[ii].name).fadeOut(300).remove()
          mon.fucking_up.splice(ii, 1)
        else
          mon[e.stat] = eval(mon[e.stat] + e.impact)
          checkMin()
          checkMax()
          mon.isAlive() if typeof mon.isAlive isnt "undefined"
        ii++
      return
    if mon.fucked_up.length isnt 0 and mon.isAlive()
      console.log("What the fuck is going on?")
      iii = 0 
      nnn = mon.fucked_up.length
      while iii < nnn 
        e = mon.fucked_up[iii]
        if battle.round is e.end
          mon[e.stat] = eval(mon[e.stat] + e.restore)
          $( "." + team + " " + ".mon" + mon.index + " " + "." + mon.fucked_up[iii].name).fadeOut(300).remove()
          mon.fucked_up.splice(iii, 1)
        iii++
    i++


################################################################################################################ AI logic helpers
window.findTargetsBelowPct = (pct) ->
  i = undefined
  n = undefined
  n = playerMonNum
  i = 0
  window.aiTargets = []
  while i < n
    aiTargets.push battle.players[0].mons[i].index if battle.players[0].mons[i].hp/battle.players[0].mons[i].max_hp <= pct &&
                                                      battle.players[0].mons[i].hp > 0
    i++
window.findTargetsAbovePct = (pct) ->
  i = undefined
  n = undefined
  n = playerMonNum
  i = 0
  window.aiTargets = []
  while i < n
    aiTargets.push battle.players[0].mons[i].index if battle.players[0].mons[i].hp/battle.players[0].mons[i].max_hp >= pct &&
                                                      battle.players[0].mons[i].hp > 0
    i++
window.findTargets = (hp) ->
  i = undefined
  n = undefined
  n = playerMonNum
  i = 0
  window.aiTargets = []
  while i < n
    aiTargets.push battle.players[0].mons[i].index if battle.players[0].mons[i].hp <= hp &&
                                                      battle.players[0].mons[i].hp > 0
    i++
window.totalUserHp = ->
  i = undefined
  n = undefined
  totalCurrentHp = 0
  n = playerMonNum
  i = 0
  while i < n
    totalCurrentHp += battle.players[0].mons[i].hp
    i++
  return totalCurrentHp
window.teamPct = ->
  i = undefined
  n = undefined
  totalMaxHp = 0
  n = playerMonNum
  i = 0
  while i < n
    totalMaxHp += battle.players[0].mons[i].max_hp
    i++
  return totalUserHp()/totalMaxHp
window.getRandom = (array) ->
  return array[Math.floor(Math.random()*array.length)]
window.selectTarget = ->
  return getRandom(aiTargets)



############################################################################################################ AI logics
window.feedAiTargets = ->
  if battle.round > 5 && teamPct() > 0.6
    window.aiAbilities = [2,3]
    findTargetsAbovePct(0.5)
    findTargetsBelowPct(0.9) if aiTargets.length is 0
  else if teamPct() > 0.8
    window.aiAbilities = [0,1]
    findTargetsBelowPct(1)
  else if teamPct() <= 0.8 && teamPct() > 0.6
    window.aiAbilities = [1,2]
    findTargetsBelowPct(0.5)
    findTargetsBelowPct(0.9) if aiTargets.length is 0
  else if teamPct() <= 0.6 && teamPct() > 0.4
    window.aiAbilities = [1,3]
    findTargetsAbovePct(0.6)
    findTargetsAbovePct(0.3) if aiTargets.length is 0
  else if teamPct() <= 0.4 && teamPct() > 0.2
    window.aiAbilities = [2,3]
    findTargets(1800)
    findTargets(3500) if aiTargets.length is 0
  else if teamPct() <= 0.2
    window.aiAbilities = [0,3]
    findTargets(1000)
    findTargets(3500) if aiTargets.length is 0




################################################################################################ AI action helpers(not very dry)
window.controlAI = (monIndex) ->
  monster = battle.players[1].mons[monIndex]
  if monster.hp > 0
    $(".battle-message").text(
      monster.name + ":" + " " + getRandom(monster.speech)).
      effect("highlight", 500)
    abilityIndex = getRandom(aiAbilities)
    if monster.taunted.target is undefined 
      window.targetIndex = getRandom(aiTargets)
    else 
      window.targetIndex = monster.taunted.target
    ability = battle.players[1].mons[monIndex].abilities[abilityIndex]
    switch ability.targeta
      when "attack"
        window.targets = [1].concat [monIndex, abilityIndex, targetIndex]
        action()
        currentMon = $(".enemy .mon" + monIndex + " " + ".img")
        currentPosition = currentMon.data("position")
        targetMon = userMon(targetIndex)
        targetPosition = targetMon.data("position")
        backPosition = currentMon.position()
        topMove = targetPosition.top - currentPosition.top
        leftMove = targetPosition.left - currentPosition.left - 60
        currentMon.animate(
          "left": "+=" + leftMove.toString() + "px"
          "top": "+=" + topMove.toString() + "px"
        , 400, ->
          checkMax
          singleTargetAbilityDisplayVariable()
          if targetMon.css("display") isnt "none"
            if enemyHurt.isAlive() is false
              targetMon.effect("explode", {pieces: 30}, 1000).hide()
            else
              targetMon.effect "shake", 750
        ).animate backPosition, 400, ->
          showDamageSingle()
          hpChangeBattle()
          checkMonHealthAfterEffect()
      when "targetenemy"
        window.targets = [1].concat [monIndex, abilityIndex, targetIndex]
        currentMon = $(".enemy .mon" + monIndex + " " + ".img")
        currentMon.effect("bounce", {distance: 50, times: 1}, 800)
        targetMon = userMon(targetIndex)
        targetPosition = targetMon.data("position")
        abilityAnime = $(".single-ability-img")
        singleTargetAbilityDisplayVariable()
        abilityAnime.css(targetPosition)
        abilityAnime.attr("src", callAbilityImg).toggleClass "flipped ability-on", ->
          action()
          if targetMon.css("display") isnt "none"
            if enemyHurt.isAlive() is false
              targetMon.effect("explode", {pieces: 30}, 1000).hide()
            else
              targetMon.effect "shake", times: 10, 750
          element = $(this)
          checkMax()
          setTimeout (->
            showDamageSingle()
            hpChangeBattle()
            checkMonHealthAfterEffect()
            element.toggleClass "flipped ability-on"
            element.attr("src", "")
            return
          ), 1200
          return
      when "aoeenemy"
        window.targets = [1].concat [monIndex, abilityIndex]
        currentMon = $(".enemy .mon" + monIndex + " " + ".img")
        currentMon.effect("bounce", {distance: 50, times: 1}, 800)
        abilityAnime = $(".ability-img")
        multipleAction()
        checkMax()
        multipleTargetAbilityDisplayVariable()
        $(".ability-img").toggleClass "aoePositionUser", ->
          element = $(this)
          element.attr("src", callAbilityImg).toggleClass("flipped ability-on")
          $(".user.mon-slot .img").each ->
            if $(this).css("display") isnt "none"
              if battle.players[0].mons[$(this).data("index")].isAlive() is false
                $(this).effect("explode", {pieces: 30}, 1200).hide()
              else
                $(this).effect "shake", {times: 5, distance: 40}, 750
          setTimeout (->
            element.toggleClass "flipped ability-on aoePositionUser"
            element.attr("src", "")
            showDamageTeam(0)
            hpChangeBattle()
            checkMonHealthAfterEffect()
            return
          ), 1200
          return



############################################################################################################### AI action happening
window.ai = ->
  $(".img").removeClass("controlling")
  $(".monBut").css("visibility", "hidden")
  $(".enemy .img").attr("disabled", "true")
  toggleImg()
  $(".battle-message").fadeIn(1)
  disable($(".end-turn"))
  battle.players[0].ap = 0
  battle.players[0].turn = false
  battle.players[1].ap = 1000000000
  enemyTimer()
  setTimeout (->
    feedAiTargets()
    if teamPct() isnt 0
      controlAI 1
      return
  ), timer1
  setTimeout (->
    feedAiTargets()
    if teamPct() isnt 0
      controlAI 3
      return
  ), timer3
  setTimeout (->
    feedAiTargets()
    if teamPct() isnt 0
      controlAI 2
      return
  ), timer2
  setTimeout (->
    feedAiTargets()
    if teamPct() isnt 0
      controlAI 0
      return
  ), timer0
  setTimeout (->
    if teamPct() isnt 0
      battle.players[1].turn = false
      battle.checkRound()
      roundEffectHappening(0)
      roundEffectHappening(1)
      hpChangeBattle()
      checkMonHealthAfterEffect()
      apChange()
      enable($("button"))
      $(".ap").effect("pulsate", {times: 5}, 1500)
      $(".battle-message").fadeOut(100)
      toggleImg()
      $(".enemy .img").removeAttr("disabled")
      toggleEnemyClick()
      return
  ), timerRound



####################################################################################################### Start of Ajax
$ ->
  window.effectBin = []
  $.ajax if $(".battle").length > 0
    url: "/battles/" + $(".battle").data("index") + ".json"
    dataType: "json"
    method: "get"
    error: ->
      alert("This battle cannot be loaded!")
    success: (data) ->
      window.battle = data
      if battle.start_cutscene isnt "none"
        setTimeout (->
          $("#overlay").fadeOut 500, ->
            $(".battle-message").show(500).effect("highlight", 500).fadeOut(300)
            $(".message").css("visibility", "visible")
            $(".cutscene").css("visibility", "hidden")
            return
        ), 4000
        setTimeout (->
          $("#battle-tutorial").joyride({'tipLocation': 'top'})
          $("#battle-tutorial").joyride({})
          $(".user .img").each ->
            $(this).effect("bounce", {distance: 80, times: 5}, 1500)
        ), 6000
      else
        $(".cutscene").css("visibility", "hidden")
        $(".message").css("visibility", "visible")
        setTimeout (->
          $("#overlay").fadeOut 500, ->
            $(".battle-message").show(500).effect("highlight", 500).fadeOut(300)
            return
        ), 1500
        setTimeout (->
          $("#battle-tutorial").joyride({'tipLocation': 'top'})
          $("#battle-tutorial").joyride({})
          $(".user .img").each ->
            $(this).effect("bounce", {distance: 80, times: 5}, 1500)
        ), 3333
################################################################################################################ Battle logic
      $(".battle").css({"background": "url(#{battle.background})", "background-repeat":"none", "background-size":"cover"})
      window.playerMonNum = battle.players[0].mons.length
      window.pcMonNum = battle.players[1].mons.length
      battle.round = 1
      battle.maxAP = 40
      battle.calculateAP = ->
        if battle.round < 5
          battle.maxAP = 30 + 10 * battle.round
        else
          battle.maxAP = 80
      battle.players[0].enemies = battle.players[1].mons
      battle.players[1].enemies = battle.players[0].mons
      setAll(battle.players, "ap", battle.maxAP)
      battle.checkRound = ->
        if battle.players.every(isTurnOver)
          battle.round += 1
          battle.calculateAP()
          setAll(battle.players, "turn", true)
          setAll(battle.players, "ap", battle.maxAP)
          console.log("This round is over.")
        else
          console.log("This ain't over.")
        return
      battle.monAbility = (playerIndex, monIndex, abilityIndex, targetIndex) ->
        ability = @players[playerIndex].mons[monIndex].abilities[abilityIndex]
        player = @players[playerIndex]
        monster = @players[playerIndex].mons[monIndex]
        switch ability.targeta
          when "targetenemy", "attack"
            targets = [ player.enemies[targetIndex] ]
          when "targetally", "cleanseally"
            targets = [ player.mons[targetIndex] ]
          when "aoeenemy"
            targets = player.enemies
          when "aoeally", "aoecleanse"
            targets = player.mons
          when "aoebuffattack"
            i = 0 
            n = playerMonNum
            while i < n 
              window.teamAttackAbilities = []
              teamAttackAbilities.push(player.mons[i].abilities[0])
              i++
            targets = teamAttackAbilities
        @players[playerIndex].commandMon(monIndex, abilityIndex, targets)
        @checkRound()
      battle.evolve = (playerIndex, monIndex, evolveIndex) ->
        current_mon = @players[playerIndex].mons[monIndex]
        better_mon = @players[playerIndex].mons[monIndex].mon_evols[evolveIndex]
        added_hp = better_mon.max_hp - current_mon.max_hp
        evolved_hp = current_mon.hp + added_hp
        if battle.players[playerIndex].ap >= better_mon.ap_cost
          battle.players[playerIndex].ap -= better_mon.ap_cost
          battle.players[playerIndex].mons[monIndex] = better_mon
          fixEvolMon(battle.players[playerIndex].mons[monIndex], battle.players[playerIndex])
          evolved_mon = battle.players[playerIndex].mons[monIndex]
          battle.players[playerIndex].mons[monIndex].hp = evolved_hp
          damageBoxAnime(0, targets[1], "+" + added_hp.toString(), "rgba(50,205,50)")
          monDiv = ".0 .mon" + targets[1].toString()
          $(monDiv + " " + ".max-hp").text("/" + " " + better_mon.max_hp)
          $(monDiv + " " + ".attack").data("apcost", evolved_mon.abilities[0].ap_cost)
          $(monDiv + " " + ".ability").data("target", evolved_mon.abilities[1].targeta)
          $(monDiv + " " + ".ability").data("apcost", evolved_mon.abilities[1].ap_cost)
          hpChangeBattle()
################################################################################################################  Player logic
      $(battle.players).each ->
        player = @
        player.turn = true
        player.commandMon = (monIndex, abilityIndex, targets) ->
          p = @
          mon = p.mons[monIndex]
          abilityCost = mon.abilities[abilityIndex].ap_cost
          if p.ap >= abilityCost
            p.ap -= abilityCost
            mon.useAbility abilityIndex, targets
          else
            alert("You do not have enough ap to use this ability")
          return
        $(player.mons).each ->
          monster = @
          fixEvolMon(monster, player)
#################################################################################################################  Battle interaction
      window.feed = ->
        targets.shift()
      window.currentBut = undefined
      toggleEnemyClick()
      $(".mon-slot .mon .img, div.mon-slot").each ->
        $(this).data "position", $(this).offset()
        return
      $(".ap .ap-number").text apInfo(battle.maxAP)
      turnOnCommandA()
      $(document).on("mouseover", ".user .monBut button", ->
        description = $(this).parent().parent().children(".abilityDesc")
        $(this).css("background", "rgba(8,136,196,1)")
        if $(this).data("target") is "evolve"
          better_mon = battle.players[0].mons[targets[1]].mon_evols[0]
          worse_mon = battle.players[0].mons[targets[1]]
          added_hp = better_mon.max_hp - worse_mon.max_hp
          description.children(".panel-heading").text better_mon.name
          description.children(".panel-body").html(
            better_mon.abilities[0].name + ": " + better_mon.abilities[0].description + "<br />" +
            "<br />" + better_mon.abilities[1].name + ": " + better_mon.abilities[1].description
            )
          description.children(".panel-footer").children("span").children(".d").text "HP: +" + added_hp
          description.children(".panel-footer").children("span").children(".a").text "AP: " + better_mon.ap_cost
          description.css "visibility", "visible"
        else
          ability = battle.players[0].mons[targets[1]].abilities[$(this).data("index")]
          description.children(".panel-heading").text ability.name
          description.children(".panel-body").html ability.description
          description.children(".panel-footer").children("span").children(".d").text ability.change
          description.children(".panel-footer").children("span").children(".a").text "AP: " + ability.ap_cost
          description.css "visibility", "visible"
        return
      ).on "mouseleave", ".user .monBut button", ->
        $(this).parent().parent().children(".abilityDesc").css "visibility", "hidden"
        $(this).css("background-image", "-webkit-linear-gradient(top, #606060 0%, #131313 100%)")
        return
      $(document).on("click.endTurn", "button.end-turn", ai)
##########################################################################################################  User move interaction
      $(document).on "click.button", ".user.mon-slot .monBut button", ->
        $(".end-turn").prop("disabled", true)
        ability = $(this)
        if window.battle.players[0].ap >= ability.data("apcost")
          $(".abilityDesc").css "visibility", "hidden"
          $(".user .monBut").css "visibility","hidden"
          toggleImg()
          $(document).on "click.cancel",".cancel", ->
            $(".user .img").removeClass("controlling")
            $(".battle-guide").hide()
            $(".end-turn").prop("disabled", false)
            $(document).off "click.boom", ".enemy.mon-slot .img"
            $(document).off "click.help", ".user.mon-slot .img"
            $(document).off "click.cancel", ".cancel"
            $(".enemy .img").each ->
              $(this).prop("disabled", true)
            toggleImg()
            if ability.data("target") is "targetally" || ability.data("target") is "ability"
              toggleImg()
              turnOnCommandA()
            targets = []
            return
          window.targets = targets.concat(ability.data("index"))  if targets.length isnt 3
          if targets.length isnt 0
            switch ability.data("target")
########################################################################################################  Player ability interaction
              when "attack"
                toggleEnemyClick()
                $(".battle-guide.guide").text("Select an enemy target")
                $(".battle-guide").show()
                $(document).on "click.boom", ".enemy.mon-slot .img", ->
                  disable(ability)
                  singleTargetAbilityAfterClickDisplay()
                  targetMon = $(this)
                  monDiv = targetMon.parent()
                  window.targets = targets.concat(monDiv.data("index"))
                  targetPosition = $(this).data("position")
                  currentPosition = currentMon.data("position")
                  backPosition = currentMon.position()
                  topMove = targetPosition.top - currentPosition.top
                  leftMove = targetPosition.left - currentPosition.left + 60
                  currentMon.animate(
                   "left": "+=" + leftMove.toString()  + "px"
                   "top": "+=" + topMove.toString()  + "px"
                  , 333, ->
                    action()
                    checkMax()
                    singleTargetAbilityDisplayVariable()
                    if targetMon.css("display") isnt "none"
                      if enemyHurt.isAlive() is false
                        targetMon.css("transform":"scaleX(-1)").effect("explode", {pieces: 30}, 1000).hide()
                      else
                        targetMon.effect "shake", 750
                    showDamageSingle()
                  ).animate backPosition, 333, ->
                    singleTargetAbilityAfterActionDisplay()
                    toggleEnemyClick()
                    return
                  return
              when "targetenemy"
                toggleEnemyClick()
                $(".battle-guide.guide").text("Select an enemy target")
                $(".battle-guide").show()
                $(document).on "click.boom", ".enemy.mon-slot .img", ->
                  disable(ability)
                  singleTargetAbilityAfterClickDisplay()
                  targetMon = $(this)
                  monDiv = targetMon.parent()
                  window.targets = targets.concat(monDiv.data("index"))
                  targetPosition = $(this).data("position")
                  abilityAnime = $(".single-ability-img")
                  singleTargetAbilityDisplayVariable()
                  abilityAnime.css(targetPosition)
                  abilityAnime.attr("src", callAbilityImg).toggleClass "ability-on", ->
                    action()
                    if targetMon.css("display") isnt "none"
                      if enemyHurt.isAlive() is false
                        targetMon.css("transform":"scaleX(-1)").effect("explode", {pieces: 30}, 1000).hide()
                      else
                        targetMon.effect "shake", times: 10, 750
                    element = $(this)
                    checkMax()
                    setTimeout (->
                      element.toggleClass "ability-on"
                      element.attr("src", "")
                      showDamageSingle()
                      singleTargetAbilityAfterActionDisplay()
                      toggleEnemyClick()
                      return
                    ), 1200
                    return
              when "targetally"
                turnOffCommandA()
                toggleImg()
                $(".battle-guide.guide").text("Select an ally target")
                $(".battle-guide").show()
                $(document).on "click.help", ".user.mon-slot .img", ->
                  $(document).off "click.help", ".user.mon-slot .img"
                  toggleImg()
                  disable(ability)
                  singleTargetAbilityAfterClickDisplay()
                  targetMon = $(this)
                  monDiv = targetMon.parent()
                  window.targets = targets.concat(monDiv.data("index"))
                  targetPosition = $(this).data("position")
                  abilityAnime = $(".single-ability-img")
                  singleHealTargetAbilityDisplayVariable()
                  abilityAnime.css(targetPosition)
                  abilityAnime.attr("src", callAbilityImg).toggleClass "ability-on", ->
                    targetMon.effect "bounce",
                        distance: 100
                        times: 1
                      , 800
                    element = $(this)
                    action()
                    checkMax()
                    setTimeout (->
                      element.toggleClass "ability-on"
                      element.attr("src", "")
                      showHealSingle()
                      singleTargetAbilityAfterActionDisplay()
                      turnOnCommandA()
                      return
                    ), 1200
                    return
              when "aoeenemy"
                $(document).off "click.cancel", ".cancel"
                disable(ability)
                $(".user .img").removeClass("controlling")
                ability.parent().parent().children(".abilityDesc").css "visibility", "hidden"
                abilityAnime = $(".ability-img")
                multipleTargetAbilityDisplayVariable()
                $(".ability-img").toggleClass "aoePositionFoe", ->
                  element = $(this)
                  element.attr("src", callAbilityImg).toggleClass("ability-on")
                  setTimeout (->
                    multipleAction()
                    $(".enemy.mon-slot .img").each ->
                      if $(this).css("display") isnt "none"
                        if battle.players[1].mons[$(this).data("index")].isAlive() is false
                          $(this).css("transform":"scaleX(-1)").effect("explode", {pieces: 30}, 1500).hide()
                        else
                          $(this).effect "shake", {times: 5, distance: 40}, 750
                    element.toggleClass "ability-on aoePositionFoe"
                    checkMax()
                    showDamageTeam(1)
                    singleTargetAbilityAfterActionDisplay()
                    return
                  ), 1200
                  return
              when "aoeally", "aoebuffattack"
                toggleImg()
                $(document).off "click.cancel", ".cancel"
                disable(ability)
                $(".user .img").removeClass("controlling")
                ability.parent().parent().children(".abilityDesc").css "visibility", "hidden"
                abilityAnime = $(".ability-img")
                checkMin()
                multipleAction()
                checkMax()
                multipleTargetAbilityDisplayVariable()
                $(".ability-img").toggleClass "aoePositionUser", ->
                  element = $(this)
                  element.attr("src", callAbilityImg).toggleClass("ability-on")
                  $(".user.mon-slot .img").each ->
                      if battle.players[0].mons[$(this).data("index")].hp > 0
                        $(this).effect "bounce",
                          distance: 100
                          times: 1
                        , 800
                  setTimeout (->
                    element.toggleClass "ability-on aoePositionUser"
                    element.attr("src", "")
                    if ability.modifier isnt ""
                      showHealTeam(0)
                    singleTargetAbilityAfterActionDisplay()
                    toggleImg()
                    return
                  ), 1200
                  return
              when "evolve"
                $(document).off "click.cancel", ".cancel"
                $(".user .img").removeClass("controlling")
                ability.remove()
                abilityAnime = $(".single-ability-img")
                targetMon = $(".0 .mon" + targets[1] + " " + ".img")
                betterMon = battle.players[0].mons[targets[1]].mon_evols[0]
                abilityAnime.css(targetMon.data("position"))
                abilityAnime.attr("src", betterMon.animation).toggleClass "ability-on", ->
                  $(".battle").effect("shake")
                  targetMon.fadeOut 500, ->
                    $(this).attr("src", betterMon.image).fadeIn(1000)
                setTimeout (->
                  battle.evolve(0, targets[1], 0)
                  $(".0 .mon" + targets[1] + " " + ".avatar").fadeOut(250).attr("src", betterMon.portrait).fadeIn(500)
                  abilityAnime.toggleClass "ability-on"
                  abilityAnime.attr("src", "")
                  apChange()
                  toggleImg()
                  flashEndButton()
                  return
                ), 2000
                return
        else
          $(this).add(".ap").effect("highlight", {color: "red"}, 100)
          $(".end-turn").prop("disabled", false)






