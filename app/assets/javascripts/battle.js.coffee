# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

################################################################################################# Battle logic helpers
window.isTeamDead = (monster, index, array) ->
  monster.isAlive() is false
window.isTurnOver = (object, index, array) ->
  object.turn is false
window.setAll = (array, attr, value) ->
  n = array.length
  i = 0
  while i < n
    array[i][attr] = value
    i++
  return
window.checkMax = ->
  n = battle.players[0].mons.length
  i = 0
  while i < n
    mon = battle.players[0].mons[i]
    battle.players[0].mons[i].hp = mon.max_hp if mon.hp > mon.max_hp
    i++
  return
window.findTargets = (hp) ->
  i = undefined
  n = undefined
  n = 3
  i = 0
  window.aiTargets = []
  while i <= n
    aiTargets.push battle.players[0].mons[i].index if battle.players[0].mons[i].hp <= hp &&
                                                          battle.players[0].mons[i].hp > 0
    i++
  return
window.teamPct = ->
  i = undefined
  n = undefined
  totalCurrentHp = 0
  totalMaxHp = 0
  n = 3
  i = 0
  while i <= n
    totalCurrentHp += battle.players[0].mons[i].hp
    totalMaxHp += battle.players[0].mons[i].max_hp
    i++
  return totalCurrentHp/totalMaxHp
window.getRandom = (array) ->
  return array[Math.floor(Math.random()*array.length)]
window.selectTarget = ->
  return getRandom(aiTargets)
window.action = ->
  battle.monAbility(targets[0], targets[1], targets[2], targets[3])
window.multipleAction = ->
  battle.monAbility(targets[0], targets[1], targets[2])



################################################################################################ Battle display helpers
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
  "." + side + ".info" + " " + ".mon" + index.toString() + " " + ".current-hp"

window.hpBarChange = (side, index) ->
  "." + side + " " + ".mon" + index.toString() + " " + ".hp .bar"

window.hpChangeBattle = ->
  i = undefined
  n = undefined
  n = 3
  i = 0
  while i <= n
    battle.players[0].mons[i].hp = (if (battle.players[0].mons[i].hp < 0) then 0 else battle.players[0].mons[i].hp)
    battle.players[1].mons[i].hp = (if (battle.players[1].mons[i].hp < 0) then 0 else battle.players[1].mons[i].hp)
    $(hpBarChange("0", i)).animate barChange(battle.players[0].mons[i].hp, battle.players[0].mons[i].max_hp), 200 if battle.
                    players[0].mons[i].hp.toString() != $(".user.info" + " " + ".mon" + i.toString() + " " + ".current-hp").text()
    $(hpChange("0", i)).text battle.players[0].mons[i].hp
    $(hpBarChange("1", i)).animate barChange(battle.players[1].mons[i].hp, battle.players[1].mons[i].max_hp), 200 if battle.
                    players[1].mons[i].hp.toString() != $(".user.info" + " " + ".mon" + i.toString() + " " + ".current-hp").text()
    $(hpChange("1", i)).text battle.players[1].mons[i].hp
    i++

window.damageBoxAnime= (team, target, damage, color) ->
  $("." + team + " " + ".mon" + target + " " + "p.dam").text(damage).animate({"color":color, "font-weight":"bold"}, 1).
  fadeIn(1).animate({"top":"-=50px", "z-index":"+=10000"}, 300).effect("bounce", {times: 10}).fadeOut().
  animate({"top":"+=50px", "z-index":"-=10000" })

window.showDamageSingle = ->
  damageBoxAnime(enemyHurt.team, enemyHurt.index, ability.modifier + ability.change, "rgba(255, 0, 0)")

window.showHealSingle = ->
  damageBoxAnime(allyHealed.team, allyHealed.index, ability.modifier + ability.change, "rgba(50,205,50)")

window.showDamageTeam = (index) ->
  i = undefined
  n = undefined
  n = 3
  i = 0
  while i <= n
    damageBoxAnime(index, i.toString(), ability.modifier + ability.change, "rgba(255, 0, 0)")
    i++

window.showHealTeam = (index) ->
  i = undefined
  n = undefined
  n = 3
  i = 0
  while i <= n
    damageBoxAnime(index, i.toString(), "1000", "rgba(0, 60, 255)")
    i++

window.singleTargetAbilityDisplayVariable = (teamIndex) ->
  window.enemyHurt = battle.players[targets[teamIndex]].enemies[targets[3]]
  window.monsterUsed = battle.players[targets[teamIndex]].mons[targets[1]]
  window.ability = battle.players[targets[teamIndex]].mons[targets[1]].abilities[targets[2]]

window.singleHealTargetAbilityDisplayVariable = (teamIndex) ->
  window.allyHealed = battle.players[targets[teamIndex]].mons[targets[3]]
  window.monsterUsed = battle.players[targets[teamIndex]].mons[targets[1]]
  window.ability = battle.players[targets[teamIndex]].mons[targets[1]].abilities[targets[2]]

window.multipleTargetAbilityDisplayVariable = (teamIndex) ->
  window.ability = battle.players[targets[teamIndex]].mons[targets[1]].abilities[targets[2]]
  window.monsterUsed = battle.players[targets[teamIndex]].mons[targets[1]]


################################################################################################# Battle interaction helpers
window.control = ->
  button = $(this).prev().css("visibility")
  if button is "visible"
    $(".user .monBut").css "visibility","hidden"
  else
    $(".user .monBut").css "visibility","hidden"
    $(this).prev().css "visibility", "visible"
    mon = $(this).closest(".mon").data("index")
    team = $(this).closest(".mon-slot").data("team")
    window.currentMon = $(this)
    window.targets = [
      team
      mon
    ]
  return

window.turnOnCommand = (funk) ->
  $(document).on "click.command", ".user.mon-slot .img", funk

window.turnOffCommand = (funk) ->
  $(document).off "click.command", ".user.mon-slot .img", funk

window.turnOff = (name, team) ->
  $(document).off name, team + ".mon-slot .img"

window.disable = (button) ->
  button.attr("disabled", "true")
  button.animate({"background-color":"rgba(192, 192, 192, 0.6)", "border-color":"rgba(192, 192, 192, 0.6)"
                , "opacity":"0.6"})

window.enable = (button) ->
  button.removeAttr("disabled")
  button.animate({"background-color":"rgba(10, 170, 230, 0.80)", "border-color":"rgba(10, 170, 230, 0.80)"
                , "opacity":"1"})



########################################################################################################## AI
window.ai = ->
  disable($(".end-turn"))
  battle.players[0].ap = 0
  battle.players[0].turn = false
  if battle.players[1].mons[1].hp > 0
    $(".enemy .mon1 .img").effect "shake", {times: 50}
    findTargets(40000)
    window.aiTarget = selectTarget()
    window.targets = [1, 1, 0].concat aiTarget
    action()
  $(".enemy .mon1 .img, .user.info .bar").promise().done ->
    hpChangeBattle()
    unless typeof battle.players[0].mons[aiTarget] is "undefined"
      if battle.players[0].mons[aiTarget].hp <= 0
        $(".user .mon" + aiTarget.toString() + " " + ".img").effect "explode",
          pieces: 20
    if battle.players[1].mons[3].hp > 0
      $(".enemy .mon3 .img").effect "shake", {times: 50}
      findTargets(40000)
      aiTarget = selectTarget()
      window.targets = [1, 1, 0].concat aiTarget
      action()
    $(".enemy .mon3 .img, .user.info .bar").promise().done ->
      hpChangeBattle()
      unless typeof battle.players[0].mons[aiTarget] is "undefined"
        if battle.players[0].mons[aiTarget].hp <= 0
          $(".user .mon" + aiTarget.toString() + " " + ".img").effect "explode",
            pieces: 20
      if battle.players[1].mons[2].hp > 0
        $(".enemy .mon2 .img").effect "shake", {times: 50}
        findTargets(40000)
        aiTarget = selectTarget()
        window.targets = [1, 1, 0].concat aiTarget
        action()
      $(".enemy .mon2 .img, .user.info .bar").promise().done ->
        hpChangeBattle()
        unless typeof battle.players[0].mons[aiTarget] is "undefined"
          if battle.players[0].mons[aiTarget].hp <= 0
            $(".user .mon" + aiTarget.toString() + " " + ".img").effect "explode",
              pieces: 20
        if battle.players[1].mons[0].hp > 0
          $(".enemy .mon0 .img").effect "shake", {times: 50}
          findTargets(40000)
          aiTarget = selectTarget()
          window.targets = [1, 1, 0].concat aiTarget
          action()
        $(".enemy .mon0 .img, .user.info .bar").promise().done ->
          unless typeof battle.players[0].mons[aiTarget] is "undefined"
            if battle.players[0].mons[aiTarget].hp <= 0
              $(".user .mon" + aiTarget.toString() + " " + ".img").effect "explode",
                pieces: 20
          hpChangeBattle()
          battle.players[1].turn = false
          battle.checkRound()
          apChange()
          enable($("button"))
          $(".ap").effect("highlight", 2000)


############################################################################################ Start of Ajax
$ ->
  $.ajax if $(".battle").length > 0
    url: "http://localhost:3000/battles/" + $(".battle").data("index") + ".json"
    dataType: "json"
    method: "get"
    error: ->
      alert("This battle cannot be loaded!")
    success: (data) ->
############################################################################################### Battle logic
      window.battle = data
      battle.round = 1
      battle.maxAP = 200
      battle.calculateAP = ->
        battle.maxAP = 10 * battle.round
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
      battle.outcome = ->
        if @players[0].mons.every(isTeamDead) is true
          alert("You have lost!")
        else if @players[1].mons.every(isTeamDead) is true
          alert("You have won!")
        return
      battle.monAbility = (playerIndex, monIndex, abilityIndex, targetIndex) ->
        ability = @players[playerIndex].mons[monIndex].abilities[abilityIndex]
        player = @players[playerIndex]
        monster = @players[playerIndex].mons[monIndex]
        switch ability.targeta
          when "targetenemy" or "attack"
            targets = [ player.enemies[targetIndex] ]
          when "targetally"
            targets = [ player.mons[targetIndex] ]
          when "aoeenemy"
            targets = player.enemies
          when "aoeally"
            targets = player.mons
          when "ability"
            targets = [player.mons[targetIndex].abilities[0]]
        @players[playerIndex].commandMon(monIndex, abilityIndex, targets)
        @outcome()
        @checkRound()
#################################################################################################  Player logic
      $(battle.players).each ->
        player = @
        player.turn = true
        player.commandMon = (monIndex, abilityIndex, targets) ->
          p = @
          mon = p.mons[monIndex]
          abilityCost = mon.abilities[abilityIndex].ap_cost
          console.log(abilityCost)
          console.log(p.ap)
          if p.ap >= abilityCost
            p.ap -= abilityCost
            mon.useAbility abilityIndex, targets
          else
            alert("You do not have enough ap to use this ability")
          return
#################################################################################################  Monster logic
        $(player.mons).each ->
          monster = @
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
            effectTargets = ability.effectTargets
            ability.use(abilityTargets, effectTargets)
##################################################################################################  Ability logic
          $(monster.abilities).each ->
            ability = @
            ability.effectTargets = []
            ability.effects.forEach (effect, index) ->
              effectTargets = []
              switch effect.targeta
                when "self"
                  effectTargets.push monster
                  ability.effectTargets.push effectTargets
                when "aoeally"
                  effectTargets.push player.mons
                  ability.effectTargets.push effectTargets
                when "aoeenemy"
                  effectTargets.push player.enemies
                  ability.effectTargets.push effectTargets
            ability.use = (abilitytargets, effectTargets) ->
              a = this
              i = 0
              while i < abilitytargets.length
                monTarget = abilitytargets[i]
                console.log(a.modifier + a.change)
                monTarget[a.stat] = eval(monTarget[a.stat] + a.modifier + a.change)
                monTarget.isAlive()
                i++
              if typeof effectTargets isnt "undefined"
                i = 0
                while i < effectTargets.length
                  effect = a.effects[i]
                  targets = effectTargets[i]
                  console.log(effect)
                  console.log(targets)
                  effect.activate targets
                  i++
              return
##################################################################################################### Effect logic
            $(ability.effects).each ->
              @activate = (effectTargets) ->
                e = this
                i = 0
                while i < effectTargets.length
                  monTarget = effectTargets[i]
                  monTarget[e.stat] = eval(monTarget[e.stat] + e.modifier + e.change)
                  monTarget.isAlive()
                  i++
                 return
###############################################################################################  Battle interaction
      window.feed = ->
        targets.shift()
      window.currentBut = undefined
      $(".mon-slot .mon .img, div.mon-slot").each ->
        $(this).data "position", $(this).offset()
        return
      $(".ap .ap-number").text apInfo(battle.maxAP)
      turnOnCommand(control)
      $(document).on("mouseover", ".user .monBut button", ->
        $(this).parent().parent().children(".abilityDesc").css "visibility", "visible"
        return
      ).on "mouseleave", ".user .monBut button", ->
        $(this).parent().parent().children(".abilityDesc").css "visibility", "hidden"
        return
      $(document).on("click.endTurn", "button.end-turn", ai)
###############################################################################################  User move interaction
      $(document).on "click.button", ".user.mon-slot .monBut button", ->
        ability = $(this)
        if window.battle.players[0].ap >= ability.data("apcost")
          turnOffCommand(control)
          $(".user .monBut").css("visibility","hidden")
          $(document).on "click.cancel",".user.mon-slot .img", ->
            turnOff("click.boom", ".enemy")
            turnOff("click.cancel", ".user")
            turnOnCommand(control)
            targets = []
            return
          window.targets = targets.concat(ability.data("index"))  if targets.length isnt 3
          if targets.length isnt 0
            switch ability.data("target")
#################################################################################################  Ability interaction
              when "attack"
                $(document).on "click.boom", ".enemy.mon-slot .img", ->
                  turnOff("click.boom", ".enemy")
                  disable(ability)
                  window.targets = targets.concat(monDiv.data("index"))
                  targetMon = $(this)
                  targetPosition = $(this).data("position")
                  monDiv = targetMon.parent()
                  currentPosition = currentMon.data("position")
                  backPosition = currentMon.position()
                  topMove = targetPosition.top - currentPosition.top
                  leftMove = targetPosition.left - currentPosition.left + 60
                  currentMon.animate(
                   "left": "+=" + leftMove.toString()  + "px"
                   "top": "+=" + topMove.toString()  + "px"
                  , 500, ->
                    action()
                    singleTargetAbilityDisplayVariable(0)
                    showDamageSingle()
                    apChange()
                    hpChangeBattle()
                    if enemyHurt.isAlive() is false
                      targetMon.effect "explode", pieces: 20
                    else
                      targetMon.effect "shake", times: 10
                  ).animate backPosition, 500, ->
                    turnOff("click.cancel", ".user")
                    turnOnCommand(control)
                    return
                  return
              when "targetenemy"
                $(document).on "click.boom", ".enemy.mon-slot .img", ->
                  turnOff("click.boom", ".enemy")
                  disable(ability)
                  targetMon = $(this)
                  monDiv = targetMon.parent()
                  window.targets = targets.concat(monDiv.data("index"))
                  targetPosition = $(this).data("position")
                  abilityAnime = $(".single-ability-img")
                  singleTargetAbilityDisplayVariable(0)
                  abilityAnime.css(targetPosition)
                  abilityAnime.toggleClass "ability-on", ->
                    element = $(this)
                    element.attr "src", callAbilityImg
                    action()
                    apChange()
                    setTimeout (->
                      if enemyHurt.isAlive() is false
                        targetMon.effect "explode", pieces: 20
                      else
                        targetMon.effect "shake", times: 10
                      showDamageSingle()
                      apChange()
                      hpChangeBattle()
                      element.toggleClass "ability-on"
                      return
                    ), 1000
                    return
              when "targetally" or "ability"
                $(document).on "click.help", ".user.mon-slot .img", ->
                  turnOff("click.help", ".user")
                  disable(ability)
                  targetMon = $(this)
                  monDiv = targetMon.parent()
                  window.targets = targets.concat(monDiv.data("index"))
                  targetPosition = $(this).data("position")
                  abilityAnime = $(".single-ability-img")
                  singleHealTargetAbilityDisplayVariable(0)
                  abilityAnime.css(targetPosition)
                  abilityAnime.toggleClass "ability-on", ->
                    element = $(this)
                    element.attr "src", callAbilityImg
                    action()
                    apChange()
                    checkMax()
                    setTimeout (->
                      targetMon.effect "bounce",
                        distance: 100
                        times: 1
                      , 500
                      showHealSingle()
                      hpChangeBattle()
                      element.toggleClass "ability-on"
                      return
                    ), 1000
                    return
              when "aoeenemy"
                  ability.parent().parent().children(".abilityDesc").css "visibility", "hidden"
                  disable(ability)
                  abilityAnime = $(".ability-img")
                  multipleAction()
                  multipleTargetAbilityDisplayVariable(0)
                  $(".ability-img").toggleClass "ability-on aoePositionFoe", ->
                    element = $(this)
                    element.attr "src", callAbilityImg
                    setTimeout (->
                      $(".enemy.mon-slot .img").each ->
                        if battle.players[1].mons[$(this).data("index")].isAlive() is false
                          $(this).effect "explode", pieces: 20
                        else
                          $(this).effect "shake", times: 10
                      showDamageTeam(1)
                      apChange()
                      hpChangeBattle()
                      element.toggleClass "ability-on aoe aoePositionFoe"
                      return
                    ), 1000
                    return
              when "aoeally"
                ability.parent().parent().children(".abilityDesc").css "visibility", "hidden"
                disable(ability)
                abilityAnime = $(".ability-img")
                multipleAction()
                checkMax()
                multipleTargetAbilityDisplayVariable(0)
                $(".ability-img").toggleClass "ability-on aoePositionUser", ->
                  element = $(this)
                  element.attr "src", callAbilityImg
                  setTimeout (->
                    $(".user.mon-slot .img").each ->
                      $(this).effect "bounce",
                        distance: 100
                        times: 1
                      , 500
                    showHealTeam(0)
                    apChange()
                    hpChangeBattle()
                    element.toggleClass "ability-on aoe aoePositionFoe"
                    return
                  ), 1000
                  return
        else
          $(this).effect("highlight", {color: "red"}, 100)



