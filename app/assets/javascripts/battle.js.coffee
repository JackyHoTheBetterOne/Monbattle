# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

################################################################################################# Battle logic helpers
window.fixEvolMon = (monster, player) ->
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
        monTarget[a.stat] = eval(monTarget[a.stat] + a.modifier + a.change)
        monTarget.isAlive()
        i++
      if typeof effectTargets isnt "undefined"
        i = 0
        while i < effectTargets.length
          effect = a.effects[i]
          targets = effectTargets[i]
          effect.activate targets
          i++
      return
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
window.checkMin = ->
  n = battle.players[0].mons.length
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
  $(".user .mon" + index.toString() + " " + ".img")
window.numOfDeadFoe = ->
  num = 0
  n = 3
  i = 0
  while i <= n
    if battle.players[1].mons[i].isAlive() is false
      num += 1
    i++
  return num
window.checkEnemyDeath = (index) ->
  return !battle.players[1].mons[index].isAlive()
window.enemyTimer = ->
  window.timer1 = 0
######################################################################
  if checkEnemyDeath(1) is true
    window.timer3 = 0
  else
    window.timer3 = 2400
######################################################################
  if checkEnemyDeath(1) is true && checkEnemyDeath(3) is true
    window.timer2 = 0
  else if checkEnemyDeath(1) is true || checkEnemyDeath(3) is true
    window.timer2 = 2400
  else
    window.timer2 = 4800
######################################################################
  if checkEnemyDeath(1) && checkEnemyDeath(3) && checkEnemyDeath(2)
    window.timer0 = 0
  else if ( ( checkEnemyDeath(1) && checkEnemyDeath(2) ) || ( checkEnemyDeath(1) && checkEnemyDeath(3) ) ) ||
          ( checkEnemyDeath(2) && checkEnemyDeath(3) )
    window.timer0 = 2400
  else if ( checkEnemyDeath(1) || checkEnemyDeath(2) ) || checkEnemyDeath(3)
    window.timer0 = 4800
  else
    window.timer0 = 7200
######################################################################
  switch numOfDeadFoe()
    when 0
      window.timerRound = 9600
    when 1
      window.timerRound = 7200
    when 2
      window.timerRound = 4800
    when 3
      window.timerRound = 2400



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
    if battle.players[index].mons[i].hp > 0
      damageBoxAnime(index, i.toString(), ability.modifier + ability.change, "rgba(255, 0, 0)")
    i++

window.showHealTeam = (index) ->
  i = undefined
  n = undefined
  n = 3
  i = 0
  while i <= n
    if battle.players[index].mons[i].hp > 0
      damageBoxAnime(index, i.toString(), ability.modifier + ability.change, "rgba(0, 60, 255)")
    i++

window.outcome = ->
  if battle.players[0].mons.every(isTeamDead) is true
    $(".message").text("You lost! Now play another round instead of doing something productive")
    $("#overlay").fadeIn(1000)
    $(".battle-message").fadeOut(1000)
    $("body").on "click", ->
      $("#overlay").fadeOut(500)
      disable($(".end-turn"))
  else if battle.players[1].mons.every(isTeamDead) is true
    $(".message").text("You won! Now play another round cause you are good at this and nothing else")
    $("#overlay").fadeIn(1000)
    $(".battle-message").fadeOut(1000)
    $("body").on "click", ->
      $("#overlay").fadeOut(500)
      disable($(".end-turn"))
  return

window.checkApAvailbility = ->
  $(".monBut button").each ->
    disable($(this)) if $(this).data("apcost") > battle.players[0].ap

window.checkActionMonHealth = ->
  if battle.players[targets[0]].mons[targets[1]].hp <= 0
    $("." + targets[0].toString() + " " + ".mon" + targets[1].toString() + " " + ".img").fadeOut()



################################################################################################# Battle display variable helpers
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
window.control = ->
  button = $(this).prev().css("visibility")
  if button is "visible"
    $(".user .monBut").css "visibility","hidden"
    $(".user .img").removeClass("controlling")
  else
    $(".user .img").removeClass("controlling")
    $(".user .monBut").css "visibility","hidden"
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

window.toggleImg = ->
  $(".user .img").each ->
    if $(this).attr("disabled") is "disabled"
      $(this).removeAttr("disabled")
    else
      $(this).attr("disabled", "true")



############################################################################################################ AI logics
window.findTargetsBelowPct = (pct) ->
  i = undefined
  n = undefined
  n = 3
  i = 0
  window.aiTargets = []
  while i <= n
    aiTargets.push battle.players[0].mons[i].index if battle.players[0].mons[i].hp/battle.players[0].mons[i].max_hp <= pct &&
                                                      battle.players[0].mons[i].hp > 0
    i++
  return 
window.findTargetsAbovePct = (pct) ->
  i = undefined
  n = undefined
  n = 3
  i = 0
  window.aiTargets = []
  while i <= n
    aiTargets.push battle.players[0].mons[i].index if battle.players[0].mons[i].hp/battle.players[0].mons[i].max_hp >= pct &&
                                                      battle.players[0].mons[i].hp > 0
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
window.totalUserHp = ->
  i = undefined
  n = undefined
  totalCurrentHp = 0
  n = 3
  i = 0
  while i <= n
    totalCurrentHp += battle.players[0].mons[i].hp
    i++
  return totalCurrentHp
window.teamPct = ->
  i = undefined
  n = undefined
  totalMaxHp = 0
  n = 3
  i = 0
  while i <= n
    totalMaxHp += battle.players[0].mons[i].max_hp
    i++
  return totalUserHp()/totalMaxHp
window.getRandom = (array) ->
  return array[Math.floor(Math.random()*array.length)]
window.selectTarget = ->
  return getRandom(aiTargets)



############################################################################################################ AI target feed
window.feedAiTargets = ->
  if teamPct() > 0.8
    window.aiAbilities = [0,1]
    findTargetsBelowPct(1)
  else if teamPct() <= 0.8 && teamPct() >= 0.6
    window.aiAbilities = [1,2]
    findTargetsBelowPct(0.5)
    findTargetsAbovePct(0.8) if aiTargets.length is 0
  else if teamPct() < 0.6 && teamPct() >= 0.4
    window.aiAbilities = [0,3]
    findTargetsAbovePct(0.7)
    findTargetsAbovePct(0.4) if aiTargets.length is 0
  else if teamPct() < 0.4 && teamPct() >= 0.2
    window.aiAbilities = [2,3]
    findTargets(3000)
    findTargets(5000) if aiTargets.length is 0 
  else if teamPct() < 0.2
    window.aiAbilities = [1,3]
    findTargets(2000) 
    findTargetsBelowPct(0.5) if aiTargets.length is 0



############################################################################################################ AI action helper
window.controlAI = (monIndex) ->
  if battle.players[1].mons[monIndex].hp > 0
    $(".battle-message").text(
      battle.players[1].mons[monIndex].name + ":" + " " + "I am angry!!!!!!!!!!!!!!!!!").
      effect("highlight", 500)
    battle.players[1].ap = 1000000000
    abilityIndex = getRandom(aiAbilities)
    targetIndex = getRandom(aiTargets)
    ability = battle.players[1].mons[monIndex].abilities[abilityIndex]
    switch ability.targeta
      when "attack"
        window.targets = [1].concat [monIndex, abilityIndex, targetIndex]
        action()
        currentMon = $(".enemy .mon" + monIndex.toString() + " " + ".img")
        currentPosition = currentMon.data("position")
        targetMon = userMon(targetIndex)
        targetPosition = targetMon.data("position")
        backPosition = currentMon.position()
        topMove = targetPosition.top - currentPosition.top
        leftMove = targetPosition.left - currentPosition.left - 60
        currentMon.animate(
          "left": "+=" + leftMove.toString() + "px"
          "top": "+=" + topMove.toString() + "px"
        , 500, ->
          checkMax
          singleTargetAbilityDisplayVariable()
          showDamageSingle()
          hpChangeBattle()
          if targetMon.css("display") isnt "none"
            if enemyHurt.isAlive() is false and
              targetMon.effect("explode", {pieces: 20}, 1500).hide()
            else
              targetMon.effect "shake"
          checkActionMonHealth()
        ).animate backPosition, 500
      when "targetenemy"
        window.targets = [1].concat [monIndex, abilityIndex, targetIndex]
        currentMon = $(".enemy .mon" + monIndex.toString() + " " + ".img")
        currentMon.effect("bounce")
        targetMon = userMon(targetIndex)
        targetPosition = targetMon.data("position")
        abilityAnime = $(".single-ability-img")
        singleTargetAbilityDisplayVariable()
        abilityAnime.css(targetPosition)
        abilityAnime.attr("src", callAbilityImg).toggleClass "flipped ability-on", ->
          action()
          if targetMon.css("display") isnt "none"
            if enemyHurt.isAlive() is false
              targetMon.effect("explode", {pieces: 20}, 1500).hide()
            else
              targetMon.effect "shake", times: 10, 1000
          element = $(this)
          checkMax()
          setTimeout (->
            showDamageSingle()
            hpChangeBattle()
            checkActionMonHealth()
            element.toggleClass "flipped ability-on"
            return
          ), 1000
          return
      when "aoeenemy"
        window.targets = [1].concat [monIndex]
        currentMon = $(".enemy .mon" + monIndex.toString() + " " + ".img")
        currentMon.effect("bounce")
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
                $(this).effect("explode", {pieces: 20}, 1500).hide()
              else
                $(this).effect "shake", {times: 5, distance: 80}, 1000
          setTimeout (->
            showDamageTeam(0)
            hpChangeBattle()
            checkActionMonHealth()
            element.toggleClass "flipped ability-on aoePositionUser"
            return
          ), 1000
          return

window.AiObj = init: (monIndex) ->
  promise = controlAI(monIndex)
  promise



############################################################################################################### AI actions
window.ai = ->
  $(".img").removeClass("controlling")
  $(".monBut").css("visibility", "hidden")
  $(".enemy .img").attr("disabled", "true")
  toggleImg()
  $(".battle-message").fadeIn(1)
  disable($(".end-turn"))
  battle.players[0].ap = 0
  battle.players[0].turn = false
  enemyTimer()
  setTimeout (->
    feedAiTargets()
    outcome()
    if teamPct(0) isnt 0
      $(".battle-message").text(
        battle.players[1].mons[1].name + ":" + " " + "I sleep with your wife every morning when you are out working").
        effect("highlight", 500)
      controlAI 1
      return
  ), timer1
  setTimeout (->
    feedAiTargets()
    outcome()
    if teamPct() isnt 0
      controlAI 3
      return
  ), timer3
  setTimeout (->
    feedAiTargets()
    outcome()
    if teamPct() isnt 0
      controlAI 2
      return
  ), timer2
  setTimeout (->
    feedAiTargets()
    outcome()
    if teamPct() isnt 0
      controlAI 0
      outcome()
      return
  ), timer0
  setTimeout (->
    if teamPct() isnt 0
      battle.players[1].turn = false
      battle.checkRound()
      apChange()
      enable($("button"))
      $(".ap").effect("highlight", 2000)
      $(".battle-message").fadeOut(100)
      toggleImg()
      $(".enemy .img").removeAttr("disabled")
      checkApAvailbility()
      return
  ), timerRound



############################################################################################## Start of Ajax
$ ->
  setTimeout (->
    $("#overlay").fadeOut 500, ->
      $(".battle-message").show(500).effect("highlight", 500).fadeOut(300)
      return
  ), 1500
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
      battle.maxAP = 10
      battle.calculateAP = ->
        if battle.round < 6 
          battle.maxAP = 10 * battle.round
        else 
          battle.maxAP = 60
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
          when "targetally"
            targets = [ player.mons[targetIndex] ]
          when "aoeenemy"
            targets = player.enemies
          when "aoeally"
            targets = player.mons
          when "ability"
            targets = [player.mons[targetIndex].abilities[0]]
        @players[playerIndex].commandMon(monIndex, abilityIndex, targets)
        @checkRound()
      battle.evolve = (playerIndex, monIndex, evolveIndex) ->
        current_mon = @players[playerIndex].mons[monIndex]
        better_mon = @players[playerIndex].mons[monIndex].mon_evols[evolveIndex]
        added_hp = better_mon.max_hp - current_mon.max_hp
        if battle.players[playerIndex].ap >= better_mon.ap_cost
          battle.players[playerIndex].ap -= better_mon.ap_cost
          battle.players[playerIndex].mons[monIndex] = better_mon
          fixEvolMon(battle.players[playerIndex].mons[monIndex], battle.players[playerIndex])
          evolved_mon = battle.players[playerIndex].mons[monIndex]
          damageBoxAnime(0, targets[1], "+" + added_hp.toString(), "rgba(50,205,50)")
          monDiv = ".0 .mon" + targets[1].toString()
          $(monDiv + " " + ".max-hp").text("/" + " " + better_mon.max_hp)
          $(monDiv + " " + ".attack").data("apcost", evolved_mon.abilities[0].ap_cost)
          $(monDiv + " " + ".ability").data("target", evolved_mon.abilities[1].targeta)
          $(monDiv + " " + ".ability").data("apcost", evolved_mon.abilities[1].ap_cost)
          hpChangeBattle()



#################################################################################################  Player logic
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
                monTarget[a.stat] = eval(monTarget[a.stat] + a.modifier + a.change)
                monTarget.isAlive()
                i++
              if typeof effectTargets isnt "undefined"
                i = 0
                while i < effectTargets.length
                  effect = a.effects[i]
                  targets = effectTargets[i]
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
        description = $(this).parent().parent().children(".abilityDesc")
        ability = battle.players[0].mons[targets[1]].abilities[$(this).data("index")]
        description.children(".panel-heading").text ability.name
        description.children(".panel-body").text ability.description
        description.children(".panel-footer").children("span").children(".d").text ability.change
        description.children(".panel-footer").children("span").children(".a").text "AP: " + ability.ap_cost
        description.css "visibility", "visible"
        return
      ).on "mouseleave", ".user .monBut button", ->
        $(this).parent().parent().children(".abilityDesc").css "visibility", "hidden"
        return
      $(document).on("click.endTurn", "button.end-turn", ai)
      checkApAvailbility()
###############################################################################################  User move interaction
      $(document).on "click.button", ".user.mon-slot .monBut button", ->
        $(".abilityDesc").css "visibility", "hidden"
        ability = $(this)
        if window.battle.players[0].ap >= ability.data("apcost")
          turnOffCommand(control)
          $(".user .monBut").css("visibility","hidden")
          # $(document).on "click.cancel",".user.mon-slot .img", ->
          #   turnOff("click.boom", ".enemy")
          #   turnOff("click.cancel", ".user")
          #   turnOnCommand(control)
          #   targets = []
          #   return
          window.targets = targets.concat(ability.data("index"))  if targets.length isnt 3
          if targets.length isnt 0
            switch ability.data("target")
#################################################################################################  Player ability interaction
              when "attack"
                $(".battle-guide").text("Select an enemy target").show()
                $(document).on "click.boom", ".enemy.mon-slot .img", ->
                  $(".user .img").removeClass("controlling")
                  $(".battle-guide").hide()
                  toggleImg()
                  targetMon = $(this)
                  turnOff("click.boom", ".enemy")
                  disable(ability)
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
                  , 500, ->
                    action()
                    checkMax()
                    singleTargetAbilityDisplayVariable()
                    showDamageSingle()
                    apChange()
                    hpChangeBattle()
                    if targetMon.css("display") isnt "none"
                      if enemyHurt.isAlive() is false
                        targetMon.effect("explode", {pieces: 20}, 1500).hide()
                      else
                        targetMon.effect "shake"
                  ).animate backPosition, 500, ->
                    checkActionMonHealth()
                    turnOff("click.cancel", ".user")
                    outcome()
                    checkApAvailbility()
                    toggleImg()
                    turnOnCommand(control)
                    return
                  return
              when "targetenemy"
                $(".battle-guide").text("Select an enemy target").show()
                $(document).on "click.boom", ".enemy.mon-slot .img", ->
                  $(".user .img").removeClass("controlling")
                  $(".battle-guide").hide()
                  toggleImg()
                  turnOff("click.boom", ".enemy")
                  disable(ability)
                  targetMon = $(this)
                  monDiv = targetMon.parent()
                  window.targets = targets.concat(monDiv.data("index"))
                  targetPosition = $(this).data("position")
                  abilityAnime = $(".single-ability-img")
                  singleTargetAbilityDisplayVariable()
                  abilityAnime.css(targetPosition)
                  abilityAnime.attr("src", callAbilityImg).toggleClass "ability-on", ->
                    if targetMon.css("display") isnt "none"
                      if enemyHurt.isAlive() is false
                        targetMon.effect("explode", {pieces: 20}, 1500).hide()
                      else
                        targetMon.effect "shake", times: 10, 1000
                    element = $(this)
                    action()
                    checkMax()
                    apChange()
                    setTimeout (->
                      showDamageSingle()
                      hpChangeBattle()
                      element.toggleClass "ability-on"
                      checkActionMonHealth()
                      outcome()
                      checkApAvailbility()
                      toggleImg()
                      turnOnCommand(control)
                      return
                    ), 1000
                    return
              when "targetally", "ability"
                $(".battle-guide").text("Select an ally target").show()
                $(document).on "click.help", ".user.mon-slot .img", ->
                  $(".user .img").removeClass("controlling")
                  $(".battle-guide").hide()
                  toggleImg()
                  turnOff("click.help", ".user")
                  disable(ability)
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
                    apChange()
                    checkMax()
                    setTimeout (->
                      showHealSingle()
                      hpChangeBattle()
                      element.toggleClass "ability-on"
                      checkActionMonHealth()
                      outcome()
                      checkApAvailbility()
                      toggleImg()
                      turnOnCommand(control)
                      return
                    ), 1000
                    return
              when "aoeenemy"
                  $(".user .img").removeClass("controlling")
                  toggleImg()
                  ability.parent().parent().children(".abilityDesc").css "visibility", "hidden"
                  disable(ability)
                  abilityAnime = $(".ability-img")
                  multipleTargetAbilityDisplayVariable()
                  $(".ability-img").toggleClass "aoePositionFoe", ->
                    element = $(this)
                    element.attr("src", callAbilityImg).toggleClass("ability-on")
                    setTimeout (->
                      showDamageTeam(1)
                      multipleAction()
                      $(".enemy.mon-slot .img").each ->
                        if $(this).css("display") isnt "none"
                          if battle.players[1].mons[$(this).data("index")].isAlive() is false
                            $(this).effect("explode", {pieces: 20}, 1500).hide()
                          else
                            $(this).effect "shake", {times: 5, distance: 80}, 1000
                      checkMax()
                      apChange()
                      hpChangeBattle()
                      element.toggleClass "ability-on aoePositionFoe"
                      checkActionMonHealth()
                      outcome()
                      checkApAvailbility()
                      toggleImg()
                      turnOnCommand(control)
                      return
                    ), 1000
                    return
              when "aoeally"
                $(".user .img").removeClass("controlling")
                toggleImg()
                ability.parent().parent().children(".abilityDesc").css "visibility", "hidden"
                disable(ability)
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
                    showHealTeam(0)
                    apChange()
                    hpChangeBattle()
                    element.toggleClass "ability-on aoePositionUser"
                    checkActionMonHealth()
                    checkApAvailbility()
                    toggleImg()
                    turnOnCommand(control)
                    return
                  ), 1000
                  return
              when "evolve"
                $(".user .img").removeClass("controlling")
                toggleImg()
                ability.remove()
                abilityAnime = $(".single-ability-img")
                targetMon = $(".0 .mon" + targets[1] + " " + ".img")
                betterMon = battle.players[0].mons[targets[1]].mon_evols[0]
                abilityAnime.css(targetMon.data("position"))
                abilityAnime.attr("src", betterMon.animation).toggleClass "ability-on", ->
                  $("body").effect("shake")
                  targetMon.fadeOut 500, ->
                    $(this).attr("src", betterMon.image).fadeIn(1000)
                setTimeout (->
                  battle.evolve(0, targets[1], 0)
                  apChange()
                  abilityAnime.toggleClass "ability-on"
                  checkApAvailbility()
                  toggleImg()
                  turnOnCommand(control)
                  return
                ), 2500
                return
            checkApAvailbility()
        else
          $(this).effect("highlight", {color: "red"}, 100)






