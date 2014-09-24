# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

###################################################################################### Battle logic helpers
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


####################################################################################### Battle display helpers 
window.apInfo = (maxAP) ->
  "AP:" + "   " + maxAP + " / " + maxAP

window.apAfterUse = (current, max) ->
  "AP:" + "   " + current + " / " + max

window.hpChangeFoe = (index) ->
  ".enemy.info" + " " + ".mon" + index.toString() + " " + ".num .current-hp" 

window.hpBarChangeFoe = (index) ->
  ".enemy.info" + " " + ".mon" + index.toString() + " " + ".hp .bar"

window.hpChangeUser = (index) ->
  ".user.info" + " " + ".mon" + index.toString() + " " + ".num .current-hp"

window.hpBarChangeUser = (index) ->
  ".user.info" + " " + ".mon" + index.toString() + " " + ".hp .bar"

window.barChange = (current, max) ->
  "width": (current/max*100).toString() + "%"

window.apNum = ".ap .ap-number"

window.apBar = ".ap-meter .bar"

window.damageShow = (team, target, damage) ->
  $("." + team + " " + ".mon" + target + " " + "p.dam").text(damage).fadeIn(100).
  animate({"top":"-=65px"}, 700).effect("bounce", {times: 3}).fadeOut().animate({"top":"+=60px"})

##################################################################################### Battle interaction helpers
window.control = ->
  button = $(this).prev().css("visibility")
  if button is "visible"
    $(".user .monBut").css "visibility","hidden"
    # $(this).prev().css "visibility", "hidden"
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
window.enable = (button) ->
  button.removeAttr("disabled")


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
      battle.maxAP = battle.round *10
      battle.players[0].enemies = battle.players[1].monsters
      battle.players[1].enemies = battle.players[0].monsters
      setAll(battle.players, "ap", battle.maxAP)
      battle.checkRound = -> 
        players = battle.players
        if players.every(isTurnOver)
          setAll(players, "turn", true)
          setAll(players, "ap", battle.maxAp)
          battle.round += 1
          console.log("This round is over.") 
        else 
          console.log("This ain't over.")
        return
      battle.outcome = ->
        if @players[0].monsters.every(isTeamDead) is true
          console.log "You have lost."
        else if @players[1].monsters.every(isTeamDead) is true
          console.log "You have won."
        else
          console.log "go fuck yourself"
        return
      battle.monAbility = (playerIndex, monIndex, abilityIndex, targetIndex) -> 
        ability = @players[playerIndex].monsters[monIndex].abilities[abilityIndex]
        player = @players[playerIndex]
        monster = @players[playerIndex].monsters[monIndex]
        switch ability.targeta
          when "targetenemy"
            targets = [ player.enemies[targetIndex] ]
          when "targetally"
            targets = [ player.monsters[targetIndex] ]
          when "aoeenemy"
            targets = player.enemies
          when "aoeally"
            targets = player.monsters
          when "ability"
            targets = [ player.monsters[targetIndex].abilities[0]]
        @players[playerIndex].commandMon(monIndex, abilityIndex, targets)
        @outcome()
        @checkRound()
#################################################################################################  Player logic
      $(battle.players).each ->
        player = @
        player.turn = true
        player.commandMon = (monIndex, abilityIndex, targets) ->
          p = @
          mon = p.monsters[monIndex]
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
        $(player.monsters).each ->
          monster = @
          monster.team = battle.players.indexOf(player)
          monster.index = player.monsters.indexOf(monster)
          monster.isAlive = -> 
            if @hp <= 0
              return false
            else
              return true
            return
          monster.useAbility = (abilityIndex, abilityTargets) ->
            ability = @abilities[abilityIndex]
            effectTargets = ability.effectTargets
            console.log(effectTargets)
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
                  effectTargets.push player.monsters
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
############################################################################################# Effect logic
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
      $(".mon-slot .mon .img").each ->
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
###############################################################################################  User move logic
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
          switch ability.data("target")
###############################################################################################  Attack logic
            when "targetenemy"
              # alert("Please pick a target")
              if targets.length isnt 0
                $(document).on "click.boom", ".enemy.mon-slot .img", ->
                  disable(ability)
                  targetMon = $(this)
                  targetPosition = $(this).data("position")
                  monDiv = targetMon.parent()
                  window.targets = targets.concat(monDiv.data("index"))
                  currentPosition = currentMon.data("position")
                  backPosition = currentMon.position()
                  topMove = targetPosition.top - currentPosition.top
                  leftMove = targetPosition.left - currentPosition.left + 60
                  currentMon.animate(
                   "left": "+=" + leftMove.toString()  + "px"
                   "top": "+=" + topMove.toString()  + "px"
                  , 500, ->
                    enemyHurt = battle.players[0].enemies[targets[3]]
                    monsterUsed = battle.players[0].monsters[targets[2]]
                    ability = battle.players[0].monsters[targets[1]].abilities[targets[2]]
                    battle.monAbility(targets[0], targets[1], targets[2], targets[3])
                    $(apNum).text apAfterUse(battle.players[0].ap , battle.maxAP)
                    $(apBar).css barChange(battle.players[0].ap, battle.maxAP)
                    damageShow(enemyHurt.team, enemyHurt.index, ability.modifier + ability.change)
                    if enemyHurt.isAlive() is false
                      targetMon.effect "explode" 
                    else
                      targetMon.effect "shake"
                    $(hpChangeFoe(targets[3])).text(enemyHurt.hp)
                    $(hpBarChangeFoe(targets[3])).css(barChange(enemyHurt.hp, enemyHurt.max_hp))
                    $(hpChangeUser(targets[2])).text(monsterUsed.hp)
                    $(hpBarChangeUser(targets[2])).css(barChange(monsterUsed.hp, monsterUsed.max_hp))
                  ).animate backPosition, 500, ->
                    turnOff("click.boom", ".enemy")                 
                    turnOff("click.cancel", ".user")
                    turnOnCommand(control)
                    return
                  return
        else
          alert "You don't have enough ap to use this ability"
          turnOffCancel
          turnOnCommand(control)
