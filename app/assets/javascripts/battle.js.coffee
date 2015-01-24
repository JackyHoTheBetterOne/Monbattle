# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

window.playIt = ->
  document.getElementById("button-click").innerHTML= "
      <audio controls autoplay class='hide'>
        <source src='https://s3-us-west-2.amazonaws.com/monbattle/music/button-press-sound-fx.wav' type='audio/mpeg'>
      </audio>
    ";
  return true;

######################################################################################################## Battle timer 
window.increaseTime = ->
  window.seconds_taken += 1
  time = window.seconds_taken
  minutes = Math.floor(time/60)
  seconds = time - minutes*60
  if seconds.toString().length > 1
    $(".battle-timer").text(minutes.toString() + ":" + seconds.toString())
  else
    $(".battle-timer").text(minutes.toString() + ":" + "0" + seconds.toString())

######################################################################################################## Monster logics
window.fixEvolMon = (monster, player) ->
  if monster.passive_ability
    if monster.passive_ability.targeta is "resistance"
      monster[monster.passive_ability.stat] += parseInt(monster.passive_ability.change)
    else if monster.passive_ability.rarita is "death-passive"
      monster.abilities.push(monster.passive_ability)
  monster.isAlive = ->
    if @hp <= 0
      if $("." + monster.team + " " + ".mon" + monster.index + " " + ".monBut").length isnt 0
        passiveScalingTeam(monster.team, "dead-friends")
      $("." + monster.team + " " + ".mon" + monster.index + " " + ".monBut").remove()
      setTimeout (->
        $("p.dam").promise().done ->
          $("." + monster.team + " " + ".mon" + monster.index + " " + ".bar").css("width", "0%")
      ), 600
      setTimeout (->
        $("p.dam, .bar").promise().done ->
          $("." + monster.team + " " + ".mon" + monster.index + " " + ".availability-arrow").remove()
          if monster.passive_ability
            if monster.passive_ability.rarita is "death-passive"
              if monster.team is 0
                deathAbilitiesToActivate["user"].push(monster.abilities[2]) if deathAbilitiesToActivate["user"].indexOf(monster.abilities[2]) is -1 
              else
                deathAbilitiesToActivate["pc"].push(monster.abilities[2]) if deathAbilitiesToActivate["pc"].indexOf(monster.abilities[2]) is -1 
              setTimeout (->
                $("." + monster.team + " " + ".mon" + monster.index + " " + ".img.passive").
                  attr("src", "https://s3-us-west-2.amazonaws.com/monbattle/images/orb.gif").
                  css("display", "initial").css("opacity", "1").attr("disabled", "true")
              ), 750
            else
              $("." + monster.team + " " + ".mon" + monster.index + " " + ".img.passive").
                css("opacity", "0") if $("." + monster.team + " " + ".mon" + monster.index + " " + ".img.passive").
                attr("src") isnt "https://s3-us-west-2.amazonaws.com/monbattle/images/orb.gif"
          $("." + monster.team + " " + ".mon" + monster.index + " " + ".img.mon-battle-image").css("opacity", "0")  
          $("." + monster.team + " " + ".mon" + monster.index + " " + ".hp").css("opacity", "0")
          $("." + monster.team + " " + ".mon" + monster.index + " " + ".num").css("opacity", "0")
          $("." + monster.team + " " + ".mon" + monster.index + " " + ".mon-name").css("opacity", "0")
          $("." + monster.team + " " + ".mon" + monster.index + " " + ".effect-box").fadeOut(300)
      ), 1300
      return false
    else
      return true
    return
  monster.useAbility = (abilityIndex, abilityTargets) ->
    ability = @abilities[abilityIndex]
    ability.use(abilityTargets)
######################################################################################################## Ability logics
  $(monster.abilities).each ->
    @team = monster.team
    @index = monster.index
    @scaling = 1
    ability = @
    a = @
    ability.use = (abilitytargets) ->
      if a.targeta.indexOf("aoe") isnt -1 && findObjectInArray(monster.cursed, "targeta", "aoe-curse") > 0
        e = usefulArray[0]
        monster[e.stat] = eval(monster[e.stat] + e.modifier + e.change)
      else if (a.targeta.indexOf("ally") isnt -1 || a.targeta.indexOf("cleanse") isnt -1) &&
              findObjectInArray(monster.cursed, "targeta", "help-curse") > 0
        e = usefulArray[0]
        monster[e.stat] = eval(monster[e.stat] + e.modifier + e.change)
      else if a.targeta.indexOf("attack") isnt -1 && findObjectInArray(monster.cursed, "targeta", "atk-curse") > 0
        e = usefulArray[0]
        monster[e.stat] = eval(monster[e.stat] + e.modifier + e.change)
      a = this
      i = 0
      while i < abilitytargets.length
        monTarget = abilitytargets[i]
        index = monTarget.index
        monTarget.isAlive()
        if monTarget.isAlive()
          if monTarget.passive_ability isnt null
            passive = monTarget.passive_ability
            if passive.targeta is "spiked-spe-shield" and a.modifier is "-"
              monster[passive.stat] = eval(monster[passive.stat] + passive.modifier + passive.change)
              showDamageSingleVariable(@team, @index, passive.modifier, passive.change)
            else if passive.targeta is "spiked-shield" and a.targeta is "attack"
              monster[passive.stat] = eval(monster[passive.stat] + passive.modifier + passive.change)
              showDamageSingleVariable(@team, @index, passive.modifier, passive.change)
            else if passive.targeta is "spe-shield" and a.modifier is "-"
              monster[passive.stat] = eval(monster[passive.stat] + passive.modifier + passive.change)
              showDamageSingleVariable(@team, @index, passive.modifier, passive.change)
          if a.targeta is "cleanseally" or a.targeta is "aoecleanse"
            ii = 0 
            while ii < monTarget.poisoned.length
              e = monTarget.poisoned[ii]
              if typeof monTarget.poisoned[ii] isnt "undefined"
                delete monTarget.poisoned[ii] if e.impact.indexOf("-") isnt -1
                removeEffectIcon(monTarget, e) 
              ii++
            i3 = 0
            while i3 < monTarget.weakened.length
              e = monTarget.weakened[i3]
              if typeof monTarget.weakened[i3] isnt "undefined"
                delete monTarget.weakened[i3] if e.restore.indexOf("+") isnt -1
                removeEffectIcon(monTarget, e)
              i3++
            if a.modifier isnt ""
              window["change" + index] = a.change*a.scaling
              Math.round(window["change" + index])
              monTarget[a.stat] = eval(monTarget[a.stat] + a.modifier + window["change" + index])
          else if a.modifier is "-" and a.targeta is "attack"
            if monster.passive
              passive = monster.passive
              if passive.targeta is "resist-penetration" 
                if passive.stat is "phy_resist" and parseInt(monTarget["phy_resist"]) > 0
                  bonus = 1 + passive.change/100
                  window["change" + index] = eval(a.change * a.scaling * bonus - monTarget["phy_resist"])
            else
              window["change" + index] = eval(a.change * a.scaling - monTarget["phy_resist"])
            Math.round(window["change" + index])
            window["change" + index] = 0 if window["change" + index].toString().indexOf("-") isnt -1
            monTarget[a.stat] = eval(monTarget[a.stat] + a.modifier + window["change" + index])
          else if a.modifier is "-" and (a.targeta is "targetenemy" or a.targeta is "aoeenemy") 
            if monster.passive
              passive = monster.passive
              if passive.targeta is "resist-penetration"
                if passive.stat is "spe_resist" and parseInt(monTarget["spe_resist"]) > 0
                  bonus = 1 + passive.change/100
                  window["change" + index] = eval(a.change * a.scaling * bonus - monTarget["spe_resist"])
            else
              window["change" + index] = eval(a.change * a.scaling - monTarget["spe_resist"])
            Math.round(window["change" + index])
            window["change" + index] = 0 if window["change" + index].toString().indexOf("-") isnt -1
            monTarget[a.stat] = eval(monTarget[a.stat] + a.modifier + window["change" + index])
          else
            window["change" + index] = a.change * a.scaling
            Math.round(window["change" + index])
            monTarget[a.stat] = eval(monTarget[a.stat] + a.modifier + window["change" + index])
            monTarget.isAlive() if typeof monTarget.isAlive isnt "undefined"
        i++
      if ability.effects.length isnt 0
        i = 0
        while i < ability.effects.length
          effect = a.effects[i]
          switch effect.targeta
            when "taunt", "poison-hp", "timed-phy-resist-buff", "timed-phy-resist-debuff"
                  , "timed-spe-resist-buff", "timed-spe-resist-debuff", "shield", "aoe-curse"
                  , "help-curse", "atk-curse"
              effect.activate abilitytargets
            when "timed-atk-buff"
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
######################################################################################################### Effect logics
    $(ability.effects).each ->
      @monDex = monster.index 
      @teamDex = monster.team
      @name = @name.replace(/\s+/g, '')
      @activate = (effectTargets) ->
        e = this
        i = 0
        if e.targeta.indexOf("curse") isnt -1 
          while i < effectTargets.length
            monTarget = effectTargets[i]
            if monTarget.isAlive()
              findObjectInArray(monTarget.cursed, "targeta", e.targeta)
              if usefulArray.length isnt 0 
                status = Object.create(e)
                monTarget.cursed.push(status)
                addEffectIcon(monTarget, e)
              else
                status = Object.create(e)
                usefulArray[0] = status
                removeEffectIcon(monTarget, e)
                addEffectIcon(monTarget, e)
            i++
        else if e.targeta.indexOf("shield") isnt -1
          while i < effectTargets.length
            monTarget = effectTargets[i]
            if monTarget.isAlive()
              if monTarget.shield.end is undefined
                addEffectIcon(monTarget, e)
              else 
                monTarget[e.stat] = eval(monTarget[e.stat] + e.restore)
                monTarget["max_hp"] = eval(monTarget["max_hp"] + e.restore) if monTarget.hp > 0
                removeEffectIcon(monTarget, e)
                addEffectIcon(monTarget, e)
              monTarget[e.stat] = eval(monTarget[e.stat] + e.modifier + e.change)
              monTarget["max_hp"] = eval(monTarget["max_hp"] + e.modifier + e.change) if monTarget.hp > 0
              monTarget.shield.name = e.name
              monTarget.shield.restore = e.restore
              monTarget.shield.targeta = e.targeta
              monTarget.shield.extra_hp = e.change
              monTarget.shield.description = e.description
              monTarget.shield.end = battle.round + e.duration
              monTarget.shield.old_hp = monTarget.hp
            i++
        else if e.targeta.indexOf("taunt") isnt -1
          while i < effectTargets.length
            monTarget = effectTargets[i]
            if monTarget.isAlive()
              if monTarget.taunted.end is undefined
                addEffectIcon(monTarget, e)
              else 
                removeEffectIcon(monTarget, e)
                addEffectIcon(monTarget, e)
              monTarget.taunted.description = e.description
              monTarget.taunted.targeta = e.targeta
              monTarget.taunted.target = monster.index
              monTarget.taunted.end = battle.round + e.duration
            i++
        else if e.targeta.indexOf("poison") isnt -1
          while i < effectTargets.length
            monTarget = effectTargets[i]
            monTarget[e.stat] = eval(monTarget[e.stat] + e.modifier + e.change)
            monTarget.shield.true_damage += parseInt(e.change) if monTarget.shield.end isnt "undefined"
            checkMax()
            monTarget.isAlive() if typeof monTarget.isAlive isnt "undefined"
            if monTarget.isAlive()
              findObjectInArray(monTarget.poisoned, "targeta", e.targeta)
              if usefulArray.length is 0
                status = {}
                status["name"] = e.name
                status["stat"] = e.stat
                status["impact"] = e.modifier + e.change
                status["change"] = e.change
                status["targeta"] = e.targeta
                status["end"] = battle.round + e.duration
                monTarget.poisoned.push(status)
                addEffectIcon(monTarget, e)
              else
                old_effect = usefulArray[0]
                removeEffectIcon(monTarget, old_effect)
                addEffectIcon(monTarget, e)
                old_effect.description = e.description
                old_effect.impact = e.modifier + e.change
                old_effect.change = e.change
                old_effect.end = battle.round + e.duration
            i++
        else if e.targeta.indexOf("timed") isnt -1
          while i < effectTargets.length
            monTarget = effectTargets[i]
            findObjectInArray(monTarget.weakened, "targeta", e.targeta)
            if monTarget.isAlive()
              if usefulArray.length is 0
                monTarget[e.stat] = eval(monTarget[e.stat] + e.modifier + e.change)
                status = {}
                status["description"] = e.description
                status["stat"] = e.stat
                status["restore"] = e.restore
                status["end"] = battle.round + e.duration
                status["targeta"] = e.targeta
                monTarget.weakened.push(status)
                addEffectIcon(monTarget, e)
              else 
                old_effect = Object.create(usefulArray[0])
                monTarget[old_effect.stat] = eval(monTarget[old_effect.stat] + old_effect.restore)
                usefulArray[0]["description"] = e.description
                usefulArray[0]["stat"] = e.stat
                usefulArray[0]["restore"] = e.restore
                usefulArray[0]["end"] = battle.round + e.duration
                monTarget[e.stat] = eval(monTarget[e.stat] + e.modifier + e.change)
                removeEffectIcon(monTarget, e)
                addEffectIcon(monTarget, e)
            i++
        else
          while i < effectTargets.length
            monTarget = effectTargets[i]
            addEffectIcon(monTarget, e)
            setTimeout (->
              $(".effect").trigger("mouseleave")
              massRemoveEffectIcon(e)
              ), 1500
            monTarget[e.stat] = eval(monTarget[e.stat] + e.modifier + e.change)
            checkMax()
            monTarget.isAlive() if typeof monTarget.isAlive isnt "undefined"
            i++



################################################################################################################ Logic helpers
window.findObjectInArray = (array, field, value) ->
  window.usefulArray = []
  i = 0 
  while i < array.length 
    if typeof array[i] isnt "undefined"
      if typeof array[i][field] isnt "undefined"         
        if array[i][field].indexOf(value) isnt -1
          usefulArray.push(array[i])
    i++
  return usefulArray.length

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

window.fixHp = ->
  n = playerMonNum
  i = 0
  while i < n 
    battle.players[0].mons[i].hp = (if (battle.players[0].mons[i].hp < 0) then 0 else battle.players[0].mons[i].hp)
    i++
  n = pcMonNum
  i = 0
  while i < n 
    battle.players[1].mons[i].hp = (if (battle.players[1].mons[i].hp < 0) then 0 else battle.players[1].mons[i].hp)
    i++

window.checkMax = ->
  i = 0
  while i < playerMonNum
    mon = battle.players[0].mons[i]
    battle.players[0].mons[i].hp = mon.max_hp if mon.hp > mon.max_hp
    i++
  i = 0 
  while i < pcMonNum
    mon = battle.players[1].mons[i]
    battle.players[1].mons[i].hp = mon.max_hp if mon.hp > mon.max_hp
    i++

window.checkMin = ->
  i = 0
  while i < playerMonNum
    mon = battle.players[0].mons[i]
    battle.players[0].mons[i].max_hp = 0 if mon.hp <= 0
    i++
  i = 0
  while i < pcMonNum
    mon = battle.players[1].mons[i]
    battle.players[1].mons[i].max_hp = 0 if mon.hp <= 0
    i++

window.userMon = (index) ->
  $(".user .mon" + index + " " + ".img")
window.pcMon = (index) ->
  $(".enemy .mon" + index + " " + ".img")

window.numOfDeadFoe = ->
  num = 0
  n = 4
  i = 0
  while i < n
    if typeof battle.players[1].mons[i] is "undefined"
      num += 1
    else if battle.players[1].mons[i].isAlive() is false
      num += 1
    i++
  return num
window.checkEnemyDeath = (index) ->
  if typeof battle.players[1].mons[index] is "undefined"
    return true
  else
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
  n = pcMonNum
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
  window.timer1 = 250
######################################################################
  if checkEnemyDeath(1) is true
    window.timer3 = 250
  else
    window.timer3 = 3000
######################################################################
  if checkEnemyDeath(1) is true && checkEnemyDeath(3) is true
    window.timer2 = 250
  else if checkEnemyDeath(1) is true || checkEnemyDeath(3) is true
    window.timer2 = 3000
  else
    window.timer2 = 5750
######################################################################
  if checkEnemyDeath(1) && checkEnemyDeath(3) && checkEnemyDeath(2)
    window.timer0 = 250
  else if ( ( checkEnemyDeath(1) && checkEnemyDeath(2) ) || ( checkEnemyDeath(1) && checkEnemyDeath(3) ) ) ||
          ( checkEnemyDeath(2) && checkEnemyDeath(3) )
    window.timer0 = 3000
  else if ( checkEnemyDeath(1) || checkEnemyDeath(2) ) || checkEnemyDeath(3)
    window.timer0 = 5750
  else
    window.timer0 = 8500
######################################################################
  switch numOfDeadFoe()
    when 0
      window.timerRound = 11250
    when 1
      window.timerRound = 8500
    when 2
      window.timerRound = 5750
    when 3
      window.timerRound = 3000
    when 4
      window.timerRound = 250



######################################################################################################## Battle display helpers
window.availableAbilities = () ->
  $(".availability-arrow").each ->
    $(this).data("available", "false")
  $(".monBut button").each ->
    button = $(this)
    if $(this).css("opacity") isnt "0"
      if $(this).data("apcost") > battle.players[0].ap
        $(button).children("img").css("opacity", "0")
        $(button).css("opacity", "0.5")
      else 
        $(button).children("img").css("opacity", "1")
        $(button).css("opacity", "1")
        $(button).parent().parent().children(".availability-arrow").data("available", "true")
  $(".availability-arrow").each ->
    if $(this).data("available") is "true"
      $(this).css("opacity", "1")
    else
      $(this).css("opacity", "0")

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


window.checkOutcome = ->
  if battle.players[0].mons.every(isTeamDead) is true or battle.players[1].mons.every(isTeamDead) is true
    window.clearInterval(battleTimer)
    vitBop()
    $(document).off "mouseover"
    turnOffCommandA()
    toggleImg()
    setTimeout (-> 
      $(".img, .ability-img, .single-ability-img").promise().done ->
        $(".img, .ability-img, .single-ability-img, p.dam, .effect-box").promise().done ->
          setTimeout (->
            $("p.dam").promise().done ->
              outcome()
          ), 500
    ), 800


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
    , 5

window.showDamageSingle = ->
  damageBoxAnime(enemyHurt.team, enemyHurt.index, ability.modifier + window["change" + enemyHurt.index], "rgba(255, 0, 0)")

window.showDamageSingleVariable = (team, monster, modifier, impact) ->
  setTimeout (->
    damageBoxAnime(team, monster, modifier + impact, "rgba(255, 0, 0)")
  ), 1500

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
    toggleImg()
    document.getElementById('battle').style.pointerEvents = 'none'
    $("#overlay").fadeIn 1000, ->
      setTimeout (->
        $(".next-scene").remove()
        $(".end-battle-box").css("z-index", "1000")
        $(".end-battle-box").addClass("animated bounceIn")
      ), 750
    $.ajax
      url: "/battles/" + battle.id
      method: "patch"
      data: {
        "victor": battle.players[1].username,
        "loser": battle.players[0].username,
        "round_taken": parseInt(battle.round),
        "time_taken": parseInt(seconds_taken)
      }
  else if battle.players[1].mons.every(isTeamDead) is true
    $(".next-scene").css("top", "-265px")
    $.ajax
      url: "/battles/" + battle.id + "/win"
      method: "get"
      data: {round_taken: parseInt(battle.round)},
      success: (response) ->
        $(".message").html(response)
        if $(".ability-earned").text() isnt ""
          sentence = "You have gained " + $(".ability-earned").text() + 
                     "! Teach it to your monster through the " + 
                     "<a href='/learn_ability'>Ability Learning</a>" + " page!" 
          newAbilities.push(sentence)
    toggleImg()
    document.getElementById('battle').style.pointerEvents = 'none'
    setTimeout (->
      $.ajax
        url: "/battles/" + battle.id
        method: "patch"
        data: {
          "victor": battle.players[0].username,
          "loser": battle.players[1].username,
          "round_taken": parseInt(battle.round),
          "time_taken": parseInt(seconds_taken)
        }
      ), 200
    if battle.end_cut_scenes.length isnt 0
      $(".cutscene").attr("src", battle.end_cut_scenes[0])
      $(".cutscene").css("opacity", "1")
      setTimeout (->
        $("#overlay").fadeIn(1000)
      ), 750
      nextSceneInitial()
    else 
      $(document).off "click.cutscene"
      $(".cutscene, .next-scene").css("opacity", "0")
      $(".message").promise().done ->
        $("#overlay").fadeIn(1000)
        setTimeout (->
          $(".next-scene, .cutscene").remove()
          $(".end-battle-box").css("z-index", "1000")
          $(".end-battle-box").addClass("bounceIn animated")
        ), 1800
    $(document).on "click.cutscene", "#overlay", ->
      if $(".cutscene").attr("src") is battle.end_cut_scenes[battle.end_cut_scenes.length-1] or 
              battle.end_cut_scenes.length is 0
        $(".cutscene").hide(500)
        endCutScene()
        setTimeout (->
          $(".next-scene, .cutscene, .skip-button").remove()
          $(".end-battle-box").css("z-index", "1000")
          $(".end-battle-box").addClass("bounceIn animated")
        ), 750
      else 
        new_index = battle.end_cut_scenes.indexOf($(".cutscene").attr("src")) + 1
        window.new_scene = battle.end_cut_scenes[new_index]
        nextScene()

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
  setTimeout (->
    $("#overlay").fadeOut 500, ->
      window.battleTimer = setInterval(increaseTime, 1000)
      toggleImg()
      # $(".battle-message").show(500).effect("highlight", 500).fadeOut(300)
      $(".user .img").each ->
        $(this).effect("bounce", {distance: 80, times: 5}, 1500)
      $(".enemy .img").each ->
        $(this).css("background", "rgba(255, 0, 0,0.5)")
      $(".foe-indication").addClass("bounceIn animated")
      setTimeout (->
        $(".foe-indication").removeClass("bounceIn animated")
        $(".foe-indication").css("opacity", "0")
        $(".enemy .img").each ->
          $(this).css("background", "transparent")
      ), 1000
    ), time
  # setTimeout (->
  #   $("#battle-tutorial").joyride({'tipLocation': 'top'})
  #   $("#battle-tutorial").joyride({})
  #   toggleImg()
  # ), (time + 1500)

################################################################################################### Display function-calling helpers
window.singleTargetAbilityAfterClickDisplay = (ability) ->
  $(".availability-arrow").each ->
    $(this).css("opacity", "0")
  disable(ability)
  $(".img").css("background", "transparent")
  $(".enemy .mon-name").css("opacity", "0")
  offUserTargetClick()
  turnOff("click.boom", ".enemy")
  turnOff("click.help", ".user")
  $(document).off "click.cancel", ".cancel"
  $(".user .img").removeClass("controlling")
  $(".battle-guide").hide()
  $(".battle-guide, .battle-guide.cancel").css("z-index", "-1")
  name = $(ability).data("name")
  $.ajax
    type: "GET"
    url: "/battles/"+ battle.id + "/tracking_abilities"
    data: { ability_name: name },
    success: (data) ->
      console.log("Successful")


window.singleTargetAbilityAfterActionDisplay = ->
  apChange()
  hpChangeBattle()
  checkMonHealthAfterEffect()
  turnOnCommandA()
  setTimeout (->
    toggleImg()
    availableAbilities()
  ), 250
  flashEndButton()

window.allyAbilityBeforeClickDisplay = ->
  userTargetClick()
  $(".battle-guide.guide").text("Select an ally target to activate")
  $(".battle-guide").show()
  $(".battle-guide.cancel, .battle-guide").css("z-index", "15000")
  turnOffCommandA()
  toggleImg()

window.enemyAbilityBeforeClickDisplay = ->
  $(".battle-guide.guide").text("Select an enemy target to activate")
  $(".battle-guide").show()
  $(".battle-guide.cancel, .battle-guide").css("z-index", "15000")
  toggleEnemyClick()
  turnOffCommandA()




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
window.userTargetClick = ->
  $(document).on("mouseover.friendly", ".user.mon-slot .img", ->
    $(this).css("background", "rgba(255, 241, 118, .58)")
  ).on "mouseleave.friendly", ".user.mon-slot .img", ->
    $(this).css("background", "transparent")


window.offUserTargetClick = ->
  $(document).off "mouseover.friendly", ".user.mon-slot .img"
  $(document).off "mouseleave.friendly", ".user.mon-slot .img"

window.endCutScene = ->
  $(document).off "click.cutscene"
  $(".cutscene").css("opacity", "0")
  $(".next-scene").css("opacity", "0")

window.nextSceneInitial = ->
  document.getElementById('overlay').style.pointerEvents = 'none'
  document.getElementById('skip-button').style.pointerEvents = 'auto' if $(".skip-button").length isnt 0
  setTimeout (->
    $(".next-scene").css("opacity", "0.9")
    document.getElementById('overlay').style.pointerEvents = 'auto'
  ), 2000

window.nextScene = ->
  if document.getElementById('overlay') isnt null
    document.getElementById('overlay').style.pointerEvents = 'none' 
    document.getElementById('skip-button').style.pointerEvents = 'auto' if $(".skip-button").length isnt 0
  $(".cutscene").css("opacity", "0")
  $(".next-scene").css("opacity", "0")
  setTimeout (->
    $(".cutscene").attr("src", new_scene)
  ), 300
  setTimeout (->
    $(".cutscene").css("opacity", "1")
  ), 1300
  setTimeout (->
    $(".next-scene").css("opacity", "0.9")
    if document.getElementById('overlay') isnt null
      document.getElementById('overlay').style.pointerEvents = 'auto'
  ), 2500

window.mouseOverMon = ->
  if $(this).css("opacity") isnt "0"
    $(this).parent().children(".monBut").css "visibility", "visible"
    $(this).parent().children(".availability-arrow").css("visibility", "hidden")
    $(this).parent().children(".availability-arrow")
    $(this).parent().children(".img").addClass("controlling") 
    $(this).parent().children(".monBut").css({"opacity":"1", "z-index":"20000"})
    mon = $(this).closest(".mon").data("index")
    team = $(this).closest(".mon-slot").data("team")
    window.currentMon = $(this)
    window.targets = [
      team
      mon
    ]

window.mouseLeaveMon = ->
  $(".availability-arrow").css("visibility", "visible")
  $(".user .monBut").css({"opacity":"0", "visibility":"hidden", "z-index":"-1"})
  $(".user .img").removeClass("controlling")

window.turnOnCommandA = ->
  $(document).on "mouseleave.command", ".user.mon-slot .mon", mouseLeaveMon
  $(document).on "mouseover.command", ".user.mon-slot .img", mouseOverMon
  $(document).on "mousemove.command", ".user.mon-slot .img", mouseOverMon

window.turnOffCommandA = ->
  $(document).off "mouseleave.command", ".user.mon-slot .mon"
  $(document).off "mouseover.command", ".user.mon-slot .img"
  $(document).off "mousemove.command", ".user.mon-slot .img"

window.turnOff = (name, team) ->
  $(document).off name, team + ".mon-slot .img"

window.disable = (button) ->
  button.attr("disabled", "true")
  button.css("opacity", 0)

window.enable = (button) ->
  button.removeAttr("disabled")
  button.css("opacity", 1)

window.toggleImg = ->
  $(".user .img.mon-battle-image").each ->
    if $(this).attr("disabled") is "disabled"
      $(this).removeAttr("disabled")
    else
      $(this).attr("disabled", "true")


window.flashEndButton = ->
  availableAbilities()
  window.buttonArray = []
  setTimeout (->
    $(".end-turn").prop("disabled", false)
    $(".end-turn").css("opacity", "1")
  ), 500
  $(".monBut button").each ->
    if $(this).parent().parent().children(".img").css("opacity") isnt "0" && $(this).attr("disabled") isnt "disabled"
      buttonArray.push $(this)
  if buttonArray.every(noApLeft) || buttonArray.every(nothingToDo)
    setTimeout (->
      $(".end-turn").trigger("click")
      return
    ), 1250
    return

window.toggleEnemyClick = ->
  $(".enemy .img").each ->
    if $(this).attr("disabled") is "disabled"
      $(this).prop("disabled", false)
    else
      $(this).prop("disabled", true)


###################################################################################################### Effect happening helpers
window.roundEffectHappening = (team) ->
  $("." + team + " " + ".effect-box").addClass("rubberBand animated")
  setTimeout (->
    $("." + team + " " + ".effect-box").removeClass("rubberBand animated")
    ), 500
  i = 0
  n = battle.players[team].mons.length
  while i < n 
    mon = battle.players[team].mons[i]
    if mon.isAlive() 
      if typeof mon.shield.end isnt "undefined"
        shieldy = parseInt(mon.shield.extra_hp) + mon.shield.true_damage - (mon.shield.old_hp - mon.hp)
        if battle.round is mon.shield.end || (mon.shield.old_hp - (mon.hp + mon.shield.true_damage)) > mon.shield.extra_hp
          removeEffectIcon(mon, mon.shield)
          mon.shield.end = undefined
          mon.max_hp = mon.max_hp - mon.shield.extra_hp if mon.hp > 0
          if shieldy > 0 
            mon.hp = mon.hp - shieldy
            mon.shield.true_damage = 0
      if mon.taunted.target isnt undefined
        if battle.round is mon.taunted.end || battle.players[0].mons[mon.taunted.target].hp <= 0
          removeEffectIcon(mon, mon.taunted)
          mon.taunted.target = undefined
      if mon.poisoned.length isnt 0
        ii = 0 
        nn = mon.poisoned.length
        while ii < nn
          e = mon.poisoned[ii]
          if typeof e isnt "undefined"
            if battle.round is e.end
              removeEffectIcon(mon, e)
              delete mon.poisoned[ii]
            else
              mon[e.stat] = eval(mon[e.stat] + e.impact)
              checkMax()
              mon.isAlive() if typeof mon.isAlive isnt "undefined"
            if e.targeta.indexOf("poison") isnt -1
              mon.shield.true_damage += parseInt(e.change)
          ii++
      if mon.weakened.length isnt 0
        i3 = 0 
        n3 = mon.weakened.length
        while i3 < n3 
          e = mon.weakened[i3]
          if typeof e isnt "undefined"
            if battle.round is e.end
              mon[e.stat] = eval(mon[e.stat] + e.restore)
              removeEffectIcon(mon, e)
              delete mon.weakened[i3]
          i3++
      if mon.cursed.length isnt 0 
        i4 = 0
        n4 = mon.cursed.length
        while i4 < n4
          e = mon.cursed[i4]
          if typeof e isnt "undefined"
            if battle.round is e.end
              removeEffectIcon(mon, e)
              delete mon.cursed[weakened]
          i4++
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

window.minimumHpPC = ->
  findAliveEnemies()
  window.healPC = liveFoes[0]
  i = 0
  while i < liveFoes.length
    if healPC.hp > liveFoes[i].hp + randomNumRange(400, 0)
      window.healPC = liveFoes[i]
    i++
  return healPC.index


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
window.controlAI = (teamIndex, monIndex, type, abilityDex) ->
  monster = battle.players[teamIndex].mons[monIndex]
  if typeof monster isnt "undefined" 
    if monster.hp > 0 or type is "death"
      if teamIndex is 1
        $(".battle-message").text(
          monster.name + ":" + " " + getRandom(monster.speech)).
          effect("highlight", 500)
      if teamIndex is 1
        abilityIndex = getRandom(aiAbilities)
        if monster.taunted.target is undefined || parseInt(battle.players[teamIndex].mons[monster.taunted.target].hp) <= 0 
          window.targetIndex = getRandom(aiTargets)
        else 
          window.targetIndex = monster.taunted.target
      else 
        abilityIndex = abilityDex
      ability = battle.players[teamIndex].mons[monIndex].abilities[abilityIndex]
      switch ability.targeta
        when "attack"
          window.targets = [1].concat [monIndex, abilityIndex, targetIndex]
          currentMon = pcMon(monIndex)
          currentPosition = currentMon.offset()
          targetMon = userMon(targetIndex)
          targetPosition = targetMon.offset()
          backPosition = currentMon.position()
          topMove = targetPosition.top - currentPosition.top
          leftMove = targetPosition.left - currentPosition.left - 60
          action()
          singleTargetAbilityDisplayVariable()
          currentMon.finish().animate(
            "left": "+=" + leftMove.toString() + "px"
            "top": "+=" + topMove.toString() + "px"
          , 540)
          setTimeout (->
            if targetMon.css("display") isnt "none"
              if enemyHurt.isAlive() is false
                targetMon.effect("explode", {pieces: 30}, 1000).hide()
              else
                targetMon.effect "shake", 800
            currentMon.finish().animate backPosition, 540
            ), 560
          setTimeout (->
            showDamageSingle()
            hpChangeBattle()
            checkMonHealthAfterEffect()
            ), 1100
        when "targetenemy"
          window.targets = [1].concat [monIndex, abilityIndex, targetIndex]
          currentMon = $(".enemy .mon" + monIndex + " " + ".img")
          currentMon.effect("bounce", {distance: 50, times: 1}, 800)
          targetMon = userMon(targetIndex)
          targetPosition = targetMon.offset()
          abilityAnime = $(".single-ability-img")
          singleTargetAbilityDisplayVariable()
          abilityAnime.css(targetPosition)
          abilityAnime.finish().attr("src", callAbilityImg).toggleClass "flipped ability-on", ->
            action()
            if targetMon.css("display") isnt "none"
              if enemyHurt.isAlive() is false
                targetMon.effect("explode", {pieces: 30}, 1000).hide()
              else
                targetMon.effect "shake", times: 10, 750
            element = $(this)
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
          window.targets = [teamIndex].concat [monIndex, abilityIndex]
          aoePosition = undefined
          if teamIndex is 1
            $(".enemy .mon" + monIndex + " " + ".img").effect("bounce", {distance: 50, times: 1}, 800) 
          if teamIndex is 1
            aoePosition = "aoePositionUser"
          else
            aoePosition = "aoePositionFoe"
          abilityAnime = $(".ability-img")
          multipleAction()
          multipleTargetAbilityDisplayVariable()
          $(".ability-img").toggleClass aoePosition, ->
            element = $(this)
            element.finish().attr("src", callAbilityImg).toggleClass("flipped ability-on")
            if teamIndex is 1
              $(".user.mon-slot .img.mon-battle-image ").each ->
                if $(this).css("display") isnt "none"
                  if battle.players[0].mons[$(this).data("index")].isAlive() is false
                    $(this).css("transform":"scaleX(-1)").effect("explode", {pieces: 30}, 1200).hide()
                  else
                    $(this).effect "shake", {times: 5, distance: 40}, 750
            else 
              $(".enemy.mon-slot .img").each ->
                if $(this).css("display") isnt "none"
                  if battle.players[1].mons[$(this).data("index")].isAlive() is false
                    $(this).effect("explode", {pieces: 30}, 1200).hide()
                  else
                    $(this).effect "shake", {times: 5, distance: 40}, 750
            setTimeout (->
              element.toggleClass "flipped ability-on"
              element.toggleClass aoePosition
              element.attr("src", "")
              if teamIndex is 1
                showDamageTeam(0)
              else 
                showDamageTeam(1)
              hpChangeBattle()
              checkMonHealthAfterEffect()            
              return
            ), 1200
            return
        when "aoeally", "aoecleanse"
          window.targets = [teamIndex].concat [monIndex, abilityIndex]
          if teamIndex is 1
            currentMon = $(".enemy .mon" + monIndex + " " + ".img")
            currentMon.effect("bounce", {distance: 50, times: 1}, 800)
          aoePosition = undefined
          if teamIndex is 1
            aoePosition = "aoePositionFoe"
          else
            aoePosition = "aoePositionUser"
          abilityAnime = $(".ability-img")
          multipleAction()
          multipleTargetAbilityDisplayVariable()
          $(".ability-img").toggleClass aoePosition, ->
            element = $(this)
            element.finish().attr("src", callAbilityImg).toggleClass("ability-on")
            images = undefined
            if teamIndex is 1
              images = ".enemy.mon-slot .img.mon-battle-image"
            else 
              images = ".user.mon-slot .img.mon-battle-image"
            $(images).each ->
              if battle.players[teamIndex].mons[$(this).data("index")].hp > 0
                $(this).effect "bounce",
                  distance: 100
                  times: 1
                , 800
            setTimeout (->
              element.toggleClass "ability-on"
              element.toggleClass aoePosition
              element.attr("src", "")
              showHealTeam(1) if ability.stat isnt "cleanse"
              hpChangeBattle()
              checkMonHealthAfterEffect()
              return
            ), 1200
            return
        when "targetally"     
          index = minimumHpPC()
          window.targets = [1].concat [monIndex, abilityIndex, index]
          currentMon = $(".enemy .mon" + monIndex + " " + ".img")
          currentMon.effect("bounce", {distance: 50, times: 1}, 800)
          targetMon = pcMonNum(index)
          targetPosition = targetMon.offset()
          abilityAnime = $(".single-ability-img")
          singleHealTargetAbilityDisplayVariable()
          abilityAnime.css(targetPosition)
          action()
          abilityAnime.finish().attr("src", callAbilityImg).toggleClass "ability-on", ->
            targetMon.effect "bounce",
              distance: 100
              times: 1
              , 800
            element = $(this)
            setTimeout (->
              showHealSingle() if ability.stat isnt "cleanse"
              element.toggleClass "ability-on"
              element.attr("src", "")
              hpChangeBattle()
              checkMonHealthAfterEffect()            
            ), 1200

############################################################################################################### AI action happening
window.ai = ->
  $(".availability-arrow").each ->
    $(this).css("opacity", "0")
  xadBuk()
  $(".img").removeClass("controlling")
  $(".monBut").css("visibility", "hidden")
  $(".enemy .img").attr("disabled", "true")
  $(".battle-message").fadeIn(1)
  battle.players[0].ap = 0
  battle.players[0].turn = false
  battle.players[1].ap = 1000000000
  zetBut()
  enemyTimer()
  setTimeout (->
    feedAiTargets()
    if teamPct() isnt 0
      controlAI(1,1,"regular","")
  ), timer1
  setTimeout (->
    feedAiTargets()
    if teamPct() isnt 0
      controlAI(1,3,"regular","")
  ), timer3
  setTimeout (->
    feedAiTargets()
    if teamPct() isnt 0
      controlAI(1,2,"regular","")
  ), timer2
  setTimeout (->
    feedAiTargets()
    if teamPct() isnt 0
      controlAI(1,0,"regular","")
  ), timer0
  setTimeout (->
    if teamPct() isnt 0
      xadBuk()
      battle.players[1].turn = false
      battle.checkRound()
      if $(".battle-round-countdown").length isnt 0
        round = parseInt($(".battle-round-countdown span").text())
        round -= 1
        if round > 0
          $(".battle-round-countdown span").text(round)
          document.getElementsByClassName("bonus-description")[0].innerHTML = 
            document.getElementsByClassName("bonus-description")[0].
            innerHTML.replace(/(\d+)/g,round)
        else 
          $(".battle-round-countdown").css("opacity", "0").remove()
      roundEffectHappening(0)
      roundEffectHappening(1)
      passiveScalingTeam(0, "round")
      passiveScalingTeam(1, "round")
      checkMonHealthAfterEffect()
      updateAbilityScaling(0, "missing-hp")
      updateAbilityScaling(1, "missing-hp")
      hpChangeBattle()
      zetBut()
      checkOutcome() if $("#overlay").css("display") is "none"
      $(".battle-message").fadeOut(100)
      $(".enemy .img").removeAttr("disabled")
      toggleEnemyClick()
      $(".monBut button").trigger("mouseleave")
      setTimeout (->
        deathAbilitiesActivation("user")
      ), 500
      timeout = undefined
      if deathAbilitiesToActivate["user"].length isnt 0 
        timeout = deathAbilitiesToActivate["user"].length*3000 + 2000
      else 
        timeout = 500
      setTimeout (->
        apChange()
        $(".ap").effect("highlight")
        toggleImg()
        availableAbilities()
        deathAbilitiesToActivate["user"].length = 0
        enable($("button"))
      ), timeout
  ), timerRound

####################################################################################################### Object action helpers
window.action = ->
  xadBuk()
  battle.monAbility(targets[0], targets[1], targets[2], targets[3])
  fixHp()
  checkMax()
  updateAbilityScaling(0, "missing-hp")
  updateAbilityScaling(1, "missing-hp")
  setTimeout (->
    zetBut()
    checkOutcome()
  ), 250

window.multipleAction = ->
  xadBuk()
  battle.monAbility(targets[0], targets[1], targets[2])
  fixHp()
  checkMax()
  updateAbilityScaling(0, "missing-hp")
  updateAbilityScaling(1, "missing-hp")
  setTimeout (->
    zetBut()
    checkOutcome()
  ), 250

# window.controlAI = (teamIndex, monIndex, type, abilityDex)

window.activateDeathAbility = (team, index) ->
  ability = deathAbilitiesToActivate[team][index]
  $("." + ability.team + " " + ".mon" + ability.index + " " + ".img.passive").
    effect("explode", {pieces: 30}, 550).remove()
  setTimeout (->
    controlAI(ability.team, ability.index, "death", 2)
  ), 800

window.deathAbilitiesActivation = (team) ->
  if deathAbilitiesToActivate[team].length isnt 0
    i = 0
    while i < deathAbilitiesToActivate[team].length
      ability = deathAbilitiesToActivate[team][i]
      delete battle.players[ability.team].mons[ability.index].passive_ability
      i++
    zetBut()
    setTimeout (->
      activateDeathAbility(team, 0)
    ), 0
    if deathAbilitiesToActivate[team].length is 2
      setTimeout (->
        activateDeathAbility(team, 1)
      ), 3000
    if deathAbilitiesToActivate[team].length is 3
      setTimeout (->
        activateDeathAbility(team, 2)
      ), 6000
######################################################################################################### Passive activation helpers
window.scaling = (passive, monster) ->
  if passive.targeta is "attack-scaling"
    monster.abilities[0].change *= (1 + passive.change/100)
  else if passive.targeta is "ability-scaling"
    monster.abilities[1].change *= (1 + passive.change/100)
  else if passive.targeta is "ultimate-scaling"
    monster.abilities[1].change *= (1 + passive.change/100)
    monster.abilities[0].change *= (1 + passive.change/100)
  monster.abilities[0].change = Math.round(monster.abilities[0].change)
  monster.abilities[1].change = Math.round(monster.abilities[1].change)


window.passiveScalingTeam = (team_num, type) ->
  mons = battle.players[team_num].mons
  i = 0
  while i < mons.length
    passive = mons[i].passive_ability
    if mons[i].passive_ability
      if passive.stat is type
        scaling(passive, mons[i])
    i++

window.passiveScalingMon = (monster, type) ->
  passive = monster.passive_ability
  if monster.passive_ability
    if passive.stat is type
      scaling(passive, monster)

window.updateAbilityScaling = (team_num, type) ->
  mons = battle.players[team_num].mons
  i = 0
  while i < mons.length
    passive = mons[i].passive_ability
    if mons[i].passive_ability
      if passive.stat is type
        if passive.targeta is "attack-scaling"
          mons[i].abilities[0].scaling = 1 + (mons[i].max_hp - mons[i].hp)*passive.change/1000
        else if passive.targeta is "ability-scaling"
          mons[i].abilities[1].scaling = 1 + (mons[i].max_hp - mons[i].hp)*passive.change/1000
        else if passive.targeta is "ultimate-scaling"
          mons[i].abilities[1].scaling = 1 + (mons[i].max_hp - mons[i].hp)*passive.change/1000
          mons[i].abilities[0].scaling = 1 + (mons[i].max_hp - mons[i].hp)*passive.change/1000
    i++

####################################################################################################### Start of Ajax
$ ->
  $(".img.mon-battle-image").each ->
    mon_image = $(this)
    href = mon_image.data("passive")
    rarity = mon_image.data("rarity")
    if href is "" or rarity is "death-passive"
      mon_image.next().css("opacity", "0")
    else
      mon_image.next().attr("src", href)
  window.effectBin = []
  window.deathAbilitiesToActivate = {}
  deathAbilitiesToActivate["user"] = []
  deathAbilitiesToActivate["pc"] = []
  if document.getElementById("battle") isnt null
    $("a.fb-nav").not(".quest-show").on "click.leave", (event) ->
      $(document).off "click.cutscene", "#overlay"
      nav = $(this)
      link = $(this).attr("href")
      text = $(this).text()
      if text isnt "Forum"
        event.preventDefault()
        $(".confirmation").css({"opacity":"1", "z-index":"10000000"})
        $(".leave-battle-but").attr("href", link)
        $("#overlay").fadeIn()
    $(".back-to-battle-but").on "click.back", (event) ->
      event.preventDefault()
      $("#overlay").fadeOut()
      $(".confirmation").css({"opacity":"0", "z-index":"-1"})
    $.ajax 
      url: "/battles/" + $(".battle").data("index") + ".json"
      dataType: "json"
      method: "get"
      error: ->
        alert("This battle cannot be loaded!")
      success: (data) ->
        window.battle = data
        window.seconds_taken = 0
        if battle.start_cut_scenes.length isnt 0 
          $(".cutscene").show(500)
          toggleImg()
          nextSceneInitial()
        else 
          $(".skip-button").remove()
          $(document).off "click.cutscene"
          battleStartDisplay(1000)
          toggleImg()
        $(document).on "click.skip", ".skip-button", ->
          if $(this).css("opacity") isnt 0
            battle.start_cut_scenes.length = 0
            battle.end_cut_scenes.length = 0
            $(".skip-button").remove()
            $(".next-scene").remove()
            $(document).off "click.skip", ".skip-button"
            zetBut()
        $(document).on "click.cutscene", "#overlay", ->
          if $(".cutscene").attr("src") is battle.start_cut_scenes[battle.start_cut_scenes.length-1] or 
              battle.start_cut_scenes.length is 0
            endCutScene()
            battleStartDisplay(1500)
          else 
            new_index = battle.start_cut_scenes.indexOf($(".cutscene").attr("src")) + 1
            window.new_scene = battle.start_cut_scenes[new_index]
            nextScene()
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
          evolved_max_hp = current_mon.max_hp + added_hp
          if battle.players[playerIndex].ap >= better_mon.ap_cost
            battle.players[playerIndex].ap -= better_mon.ap_cost
            old_mon = battle.players[playerIndex].mons[monIndex]
            battle.players[playerIndex].mons[monIndex] = better_mon
            new_mon = battle.players[playerIndex].mons[monIndex]
            new_mon.phy_resist = old_mon.phy_resist
            new_mon.spe_resist = old_mon.spe_resist
            new_mon.poisoned = old_mon.poisoned
            new_mon.weakened = old_mon.weakened
            new_mon.taunted = old_mon.taunted
            new_mon.shield = old_mon.shield
            new_mon.cursed = old_mon.cursed
            new_mon.team = old_mon.team
            new_mon.index = old_mon.index
            fixEvolMon(new_mon, battle.players[playerIndex])
            evolved_mon = battle.players[playerIndex].mons[monIndex]
            battle.players[playerIndex].mons[monIndex].hp = evolved_hp
            battle.players[playerIndex].mons[monIndex].max_hp = evolved_max_hp
            damageBoxAnime(0, targets[1], "+" + added_hp.toString(), "rgba(50,205,50)")
            monDiv = ".0 .mon" + targets[1].toString()
            $(monDiv + " " + ".max-hp").text("/" + " " + better_mon.max_hp)
            $(monDiv + " " + ".mon-name").text(better_mon.name)
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
            monster.shield = 0
            monster.phy_resist = 0
            monster.spe_resist = 0
            monster.poisoned = []
            monster.weakened = []
            monster.cursed = []
            monster.taunted = {}
            monster.shield = {}
            monster.shield.end = undefined
            monster.shield.true_damage = 0
            monster.taunted.target = undefined
            monster.team = battle.players.indexOf(player)
            monster.index = player.mons.indexOf(monster)
            fixEvolMon(monster, player)
  #################################################################################################################  Battle interaction
        window.documentURLObject = window.battle.monAbility.toString() + window.battle.players[0].commandMon.toString() + 
                                                                        window.battle.players[1].commandMon.toString()
        window.feed = ->
          targets.shift()
        window.currentBut = undefined
        zetBut()
        availableAbilities()
        toggleEnemyClick()
        $(document).on("mouseover", ".battle-round-countdown", ->
          $(".bonus-description").css({"opacity":"1", "z-index":"10000"})
        ).on "mouseleave", ".battle-round-countdown", ->
          $(".bonus-description").css({"opacity":"0", "z-index":"-1"})
        $(document).on("mouseover", ".enemy.mon-slot .img", ->
          if $(this).attr("disabled") isnt "disabled"
            $(this).css("background", "rgba(255, 241, 118, .58)")
            $(this).parent().children(".num").children(".mon-name").css("opacity", 1)
          ).on "mouseleave", ".enemy.mon-slot .img", ->
            $(this).css("background", "transparent")
            $(this).parent().children(".num").children(".mon-name").css("opacity", 0)
        $(".mon-slot .mon .img, div.mon-slot").each ->
          $(this).data "position", $(this).offset()
          return
        $(".ap .ap-number").text apInfo(battle.maxAP)
        turnOnCommandA()
        $(document).on("mouseover", ".user .monBut button", ->
          ability_target = $(this).data("target")
          description = $(this).parent().parent().children(".abilityDesc")
          if $(this).css("opacity") isnt "0"
            if $(this).data("target") is "evolve"
              description.children("span.damage-type").text ""
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
              description.css({"z-index": "11000", "opacity": "0.9"})
            else
              ability = battle.players[0].mons[targets[1]].abilities[$(this).data("index")]
              description.children(".panel-heading").text ability.name
              if ability_target is "attack"
                description.children("span.damage-type").text "Physical"
              else
                description.children("span.damage-type").text "Special"
              description.children(".panel-body").html ability.description
              description.children(".panel-footer").children("span").children(".d").text ability.change*ability.scaling
              description.children(".panel-footer").children("span").children(".a").text "AP: " + ability.ap_cost
              description.css({"z-index": "6000", "opacity": "0.9"})
          return
        ).on "mouseleave", ".user .monBut button", ->
          $(this).parent().parent().children(".abilityDesc").css({"z-index":"-1", "opacity": "0"})
          return
        $(document).on "click.endTurn", "button.end-turn", ->
          disable($(".end-turn"))
          toggleImg()
          if deathAbilitiesToActivate["pc"].length > 0
            xadBuk()
            wait = deathAbilitiesToActivate["pc"].length * 3000 + 1600
            setTimeout (->
              deathAbilitiesActivation("pc")
            ), 100
            console.log(wait)
            setTimeout (->
              deathAbilitiesToActivate["pc"] = []
              ai()
            ), wait
          else 
            ai()
        $(document).on("mouseover", ".effect", ->
          index = @id
          e = effectBin[index]
          $(".effect-info").css("opacity", "1")
          if e.targeta is "taunt" 
            $(".effect-info" + " " + ".panel-body").text("This unit wants to kill " + e.target + ".")
          else if e.targeta is "shield"
            monster = battle.players[e.enemyDex].mons[e.enemyMonDex]
            shield = parseInt(monster.shield.extra_hp) + monster.shield.true_damage - (monster.shield.old_hp - monster.hp)
            if shield <= 0 
              $(".effect-info" + " " + ".panel-body").text("This shield is broken!")
            else
              $(".effect-info" + " " + ".panel-body").text("This unit has a shield of " + shield + "HP.")
          else
            $(".effect-info" + " " + ".panel-body").text(e.description)
          $(".effect-info" + " " + ".panel-heading").text(
            "Expires in" + " " + (e.end - battle.round) + " " + "turn(s)")
        ).on "mouseleave", ".effect", -> 
          index = @id
          e = effectBin[index]
          $(".effect-info").css("opacity", "0")
  ##########################################################################################################  User move interaction
        $(document).on "click.button", ".user.mon-slot .monBut button", ->
          $(".end-turn").prop("disabled", true)
          $(".end-turn").css("opacity", "0.5")
          ability = $(this)
          if window.battle.players[0].ap >= ability.data("apcost")
            $(".abilityDesc").css({"opacity":"0", "z-index":"-1"})
            $(".user .monBut").css({"visibility":"hidden", "opacity":"0"})
            toggleImg()
            $(document).on "click.cancel",".cancel", ->
              availableAbilities()
              offUserTargetClick()
              $(".user .img").removeClass("controlling")
              $(".battle-guide").hide()
              $(".end-turn").prop("disabled", false)
              $(".end-turn").css("opacity", "1")
              $(document).off "click.boom", ".enemy.mon-slot .img"
              $(document).off "click.help", ".user.mon-slot .img"
              $(document).off "click.cancel", ".cancel"
              turnOnCommandA()
              $(".enemy .img").each ->
                $(this).prop("disabled", true)
              toggleImg()
              if ability.data("target").indexOf("ally") isnt -1 || ability.data("target") is "ability"
                toggleImg()
              targets = []
              return
            window.targets = targets.concat(ability.data("index"))  if targets.length isnt 3
            if targets.length isnt 0
              switch ability.data("target")
  ########################################################################################################  Player ability interaction
                when "attack"
                  enemyAbilityBeforeClickDisplay()
                  $(document).on "click.boom", ".enemy.mon-slot .img", ->
                    singleTargetAbilityAfterClickDisplay(ability)
                    targetMon = $(this)
                    monDiv = targetMon.parent()
                    window.targets = targets.concat(monDiv.data("index"))
                    targetPosition = $(this).offset()
                    currentPosition = currentMon.offset()
                    backPosition = currentMon.position()
                    topMove = targetPosition.top - currentPosition.top
                    leftMove = targetPosition.left - currentPosition.left + 60
                    action()
                    currentMon.finish().animate(
                      left: "+=" + leftMove.toString() + "px"
                      top: "+=" + topMove.toString() + "px"
                    , 440)
                    setTimeout (->
                      singleTargetAbilityDisplayVariable()
                      if targetMon.css("display") isnt "none"
                        if enemyHurt.isAlive() is false
                          targetMon.css("transform":"scaleX(-1)").effect("explode", {pieces: 30}, 1000).hide()
                        else
                          targetMon.effect "shake", 800
                      showDamageSingle()
                      currentMon.finish().animate backPosition, 500
                    ), 500
                    setTimeout (->
                      singleTargetAbilityAfterActionDisplay()
                      toggleEnemyClick()
                      ), 1100
                when "targetenemy"
                  enemyAbilityBeforeClickDisplay()
                  $(document).on "click.boom", ".enemy.mon-slot .img", ->
                    singleTargetAbilityAfterClickDisplay(ability)
                    targetMon = $(this)
                    monDiv = targetMon.parent()
                    window.targets = targets.concat(monDiv.data("index"))
                    targetPosition = $(this).offset()
                    abilityAnime = $(".single-ability-img")
                    singleTargetAbilityDisplayVariable()
                    abilityAnime.css(targetPosition)
                    action()
                    abilityAnime.finish().attr("src", callAbilityImg).toggleClass "ability-on", ->
                      if targetMon.css("display") isnt "none"
                        if enemyHurt.isAlive() is false
                          targetMon.css("transform":"scaleX(-1)").effect("explode", {pieces: 30}, 1000).hide()
                        else
                          targetMon.effect "shake", times: 10, 750
                      element = $(this)
                      setTimeout (->
                        element.toggleClass "ability-on"
                        element.attr("src", "")
                        singleTargetAbilityAfterActionDisplay()
                        showDamageSingle()
                        toggleEnemyClick()
                        return
                      ), 1200
                      return
                when "targetally", "cleanseally"
                  allyAbilityBeforeClickDisplay()
                  $(document).on "click.help", ".user.mon-slot .img", ->
                    toggleImg()
                    singleTargetAbilityAfterClickDisplay(ability)
                    targetMon = $(this)
                    monDiv = targetMon.parent()
                    window.targets = targets.concat(monDiv.data("index"))
                    targetPosition = $(this).offset()
                    abilityAnime = $(".single-ability-img")
                    singleHealTargetAbilityDisplayVariable()
                    abilityAnime.css(targetPosition)
                    action()
                    abilityAnime.finish().attr("src", callAbilityImg).toggleClass "ability-on", ->
                      targetMon.effect "bounce",
                          distance: 100
                          times: 1
                        , 800
                      element = $(this)
                      setTimeout (->
                        if ability.stat isnt "cleanse"
                          showHealSingle()
                        element.toggleClass "ability-on"
                        element.attr("src", "")
                        singleTargetAbilityAfterActionDisplay()
                        return
                      ), 1200
                      return
                when "aoeenemy"
                  enemyAbilityBeforeClickDisplay()
                  $(document).on "click.boom", ".enemy.mon-slot .img", ->
                    toggleEnemyClick()
                    singleTargetAbilityAfterClickDisplay(ability)
                    abilityAnime = $(".ability-img")
                    multipleTargetAbilityDisplayVariable()
                    $(".ability-img").toggleClass "aoePositionFoe", ->
                      element = $(this)
                      element.finish().attr("src", callAbilityImg).toggleClass("ability-on")
                      setTimeout (->
                        multipleAction()
                        $(".enemy.mon-slot .img").each ->
                          if $(this).css("display") isnt "none"
                            if battle.players[1].mons[$(this).data("index")].isAlive() is false
                              $(this).css("transform":"scaleX(-1)").effect("explode", {pieces: 30}, 1500).hide()
                            else
                              $(this).effect "shake", {times: 5, distance: 40}, 750
                        element.toggleClass "ability-on aoePositionFoe"
                        element.attr("src","")
                        showDamageTeam(1)
                        singleTargetAbilityAfterActionDisplay()
                        return
                      ), 1200
                      return
                when "aoeally", "aoebuffattack", "aoecleanse"
                  allyAbilityBeforeClickDisplay()
                  $(document).on "click.help", ".user.mon-slot .img", ->
                    singleTargetAbilityAfterClickDisplay(ability)
                    toggleImg()
                    abilityAnime = $(".ability-img")
                    multipleAction()
                    multipleTargetAbilityDisplayVariable()
                    $(".ability-img").toggleClass "aoePositionUser", ->
                      element = $(this)
                      element.finish().attr("src", callAbilityImg).toggleClass("ability-on")
                      $(".user.mon-slot .img").each ->
                        if battle.players[0].mons[$(this).data("index")].hp > 0
                          $(this).effect "bounce",
                            distance: 100
                            times: 1
                          , 800
                      setTimeout (->
                        element.toggleClass "ability-on aoePositionUser"
                        element.attr("src", "")
                        showHealTeam(0) if ability.stat isnt "cleanse"
                        singleTargetAbilityAfterActionDisplay()
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
                  oldMon = battle.players[0].mons[targets[1]]
                  findObjectInArray(effectBin, "target", oldMon.name)
                  i = 0
                  while i < usefulArray.length
                    usefulArray[i].target = betterMon.name
                    i++
                  abilityAnime.css(targetMon.offset())
                  abilityAnime.finish().attr("src", betterMon.animation).toggleClass "ability-on", ->
                    $(".battle").effect("shake")
                    targetMon.fadeOut 500, ->
                      $(this).finish().attr("src", betterMon.image).fadeIn(1000)
                  setTimeout (->
                    xadBuk()
                    battle.evolve(0, targets[1], 0)
                    zetBut()
                    abilityAnime.toggleClass "ability-on"
                    abilityAnime.attr("src", "")
                    apChange()
                    setTimeout (->
                      toggleImg()
                      availableAbilities()
                    ), 200
                    flashEndButton()
                    return
                  ), 2000
                  return
          else
            $(this).add(".ap").effect("highlight", {color: "red"}, 100)
            alert("You have insufficient ap to use this skill.")
            $(".end-turn").prop("disabled", false)
            $(".end-turn").css("opacity", "1")






