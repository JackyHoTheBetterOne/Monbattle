# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

window.playIt = ->
  if $(".battle-music").prop("muted") is false and $(".mute-toggle img").attr("src") isnt "https://s3-us-west-2.amazonaws.com/monbattle/images/mute-icon.png"
    document.getElementById("button-click").innerHTML= "
        <audio controls autoplay class='hide'>
          <source src='https://s3-us-west-2.amazonaws.com/monbattle/music/button-press-sound-fx.wav' type='audio/mpeg'>
        </audio>
      ";
  return true;

######################################################################################################## Tutorial helpers
window.endBattleTutorial = ->
  element = ".end-battle-box.winning"
  if $(element).data("firstcleared") is true
    if $(element).data("levelname") is "Area A - Stage 1" 
      hopscotch.startTour(edit_team_tour)
    else if $(element).data("levelname") is "Area A - Stage 2"
      hopscotch.startTour(ascend_mon_tour) 
    else if $(element).data("levelname") is "Area A - Stage 3"
      hopscotch.startTour(learn_ability_tour) 
    else if $(element).data("levelname") is "Area A - Stage 4"
      hopscotch.startTour(enhance_mon_tour)



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
  if monster.max_hp isnt 0
    monster.type = "monster"
  else 
    monster.type = "summoner"
  monster.fatigue = 0
  monster.used = false
  monster.unidex = monster.team.toString() + monster.index.toString()
  monster.isAlive = ->
    if @hp <= 0
      if $("." + monster.team + " " + ".mon" + monster.index + " " + ".monBut").length isnt 0
        passiveScalingTeam(monster.team, "dead-friends")
      $("." + monster.team + " " + ".mon" + monster.index + " " + ".monBut").css("visibility", "hidden !important")
      if monster.team is 1 && $(".stupid-text").css("opacity") is "0" && 
          $("." + monster.team + " " + ".mon" + monster.index + " " + ".mon-battle-image").css("display") isnt "none"
            setTimeout (->
              retard = ["Fantastic", "Good", "Excellent", "Nice"]
              $(".stupid-text").text(shuffle(retard)[0])
              $(".stupid-text").css("z-index","10000000000")
              $(".stupid-text").addClass("tada animated").css("opacity", "1")
              setTimeout (->
                $(".stupid-text").removeClass("tada animated").addClass("animated fadeOutUp")
              ), 1000
              setTimeout (->
                $(".stupid-text").removeClass("animated fadeOutUp").css({"z-index":"-10", "opacity":"0"})
              ), 1500
            ), 500
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
                deathAbilitiesToActivate["pc"].push(monster.abilities[4]) if deathAbilitiesToActivate["pc"].indexOf(monster.abilities[4]) is -1 
              setTimeout (->
                $("." + monster.team + " " + ".mon" + monster.index + " " + ".img.passive").
                  attr("style", "").
                  attr("src", "https://s3-us-west-2.amazonaws.com/monbattle/images/orb.gif").
                  css("display", "initial").css({"opacity": "1"}).attr("disabled", "true")
              ), 350
            else
              $("." + monster.team + " " + ".mon" + monster.index + " " + ".img.passive").
                css("opacity", "0") if $("." + monster.team + " " + ".mon" + monster.index + " " + ".img.passive").
                attr("src") isnt "https://s3-us-west-2.amazonaws.com/monbattle/images/orb.gif"
          $("." + monster.team + " " + ".mon" + monster.index + " " + ".hp").css("opacity", "0")
          $("." + monster.team + " " + ".mon" + monster.index + " " + ".fatigue-level").css("opacity", "0")
          $("." + monster.team + " " + ".mon" + monster.index + " " + ".num").css("opacity", "0")
          $("." + monster.team + " " + ".mon" + monster.index + " " + ".mon-name").css("opacity", "0")
          $("." + monster.team + " " + ".mon" + monster.index + " " + ".effect-box").fadeOut(300)
          setTimeout (->
            if $("." + monster.team + " " + ".mon" + monster.index + " " + ".img.mon-battle-image").css("display") isnt "none"
              if monster.team is 0
                $("." + monster.team + " " + ".mon" + monster.index + " " + ".img.mon-battle-image").
                  effect("explode", {pieces: 30}, 1500).hide()
              else 
                $("." + monster.team + " " + ".mon" + monster.index + " " + ".img.mon-battle-image").
                  css("transform":"scaleX(-1)").effect("explode", {pieces: 30}, 1500).hide()
          ), 200
      ), 1300
      return false
    else
      return true
    return
  monster.useAbility = (abilityIndex, abilityTargets) ->
    ability = @abilities[abilityIndex]
    ability.use(abilityTargets)
    if monster.type isnt "summoner" and battle.players[monster.team].username isnt "NPC"
      monster.fatigue += 1 if monster.fatigue != 10 
      monster.used = true
    if monster.type isnt "summoner" and battle.players[monster.team].name is "first-battle-user"
      monster.fatigue += 1 if monster.fatigue != 10
      monster.used = true
######################################################################################################## Ability logics
  $(monster.abilities).each ->
    @team = monster.team
    @index = monster.index
    @unidex = monster.unidex
    @scaling = 1
    @type = "ability"
    ability = @
    a = @
    ability.effectImpact = ->
      impact = 0 
      i = 0
      while i < a.effects.length
        if a.effects[i].targeta is "poison"
          impact += parseInt(a.effects[i].change)
        else if a.effects[i].targeta is "shield"
          impact += parseInt(a.effects[i].change)
        i++
    ability.isAlive = ->
      battle.players[@team].mons[@index].isAlive()
    ability.use = (abilitytargets) ->
      monster.used = true
      if a.targeta.indexOf("aoe") isnt -1 && findObjectInArray(monster.cursed, "targeta", "aoe-curse") > 0
        e = usefulArray[0]
        monster[e.stat] = eval(monster[e.stat] + e.modifier + e.change)
        setTimeout (->
          window["change" + monster.unidex] = eval(window["change" + monster.unidex] + "-" + e.change)
        ), 150
      else if (a.targeta.indexOf("ally") isnt -1 || a.targeta.indexOf("cleanse") isnt -1) &&
              findObjectInArray(monster.cursed, "targeta", "help-curse") > 0
        e = usefulArray[0]
        monster[e.stat] = eval(monster[e.stat] + e.modifier + e.change)
        setTimeout (->
          window["change" + monster.unidex] = eval(window["change" + monster.unidex] + "-" + e.change)
        ), 150
      else if a.targeta.indexOf("attack") isnt -1 && findObjectInArray(monster.cursed, "targeta", "atk-curse") > 0
        e = usefulArray[0]
        monster[e.stat] = eval(monster[e.stat] + e.modifier + e.change)
        setTimeout (->
          window["change" + monster.unidex] = eval(window["change" + monster.unidex] + "-" + e.change)
        ), 150
      a = this
      i = 0
      while i < abilitytargets.length
        monTarget = abilitytargets[i]
        index = monTarget.unidex
        fatigue_effect = 1 - monster.fatigue*0.1
        monTarget.isAlive()
        if monTarget.isAlive()
          if monTarget.passive_ability isnt null and 
              (ability.targeta is "attack" or ability.targeta is "targetenemy")
            passive = monTarget.passive_ability
            if passive.targeta is "spiked-spe-shield" and a.modifier is "-"
              monster[passive.stat] = eval(monster[passive.stat] + passive.modifier + passive.change)
              setTimeout (->
                window["change" + monster.unidex] = eval(window["change" + monster.unidex] + "-" + passive.change)
              ), 100
            else if passive.targeta is "spiked-shield" and a.targeta is "attack"
              monster[passive.stat] = eval(monster[passive.stat] + passive.modifier + passive.change)
              setTimeout (->
                window["change" + monster.unidex] = eval(window["change" + monster.unidex] + "-" + passive.change)
              ), 100
            else if passive.targeta is "spe-shield" and a.modifier is "-"
              monster[passive.stat] = eval(monster[passive.stat] + passive.modifier + passive.change)
              setTimeout (->
                window["change" + monster.unidex] = eval(window["change" + monster.unidex] + "-" + passive.change)
              ), 100
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
              window["change" + index] = a.change*a.scaling*fatigue_effect
              window["change" + index] = Math.round(window["change" + index])
              monTarget[a.stat] = eval(monTarget[a.stat] + a.modifier + window["change" + index])
              window["change" + index] = a.modifier + window["change" + index]
          else if a.modifier is "-" and a.targeta is "attack"
            if monster.passive
              passive = monster.passive
              if passive.targeta is "resist-penetration" 
                if passive.stat is "phy_resist" and parseInt(monTarget["phy_resist"]) > 0
                  bonus = 1 + passive.change/100
                  window["change" + index] = 
                    eval(a.change * a.scaling * bonus * fatigue_effect - monTarget["phy_resist"])
            else
              window["change" + index] = 
                eval(a.change * a.scaling * fatigue_effect - monTarget["phy_resist"])
            window["change" + index] = Math.round(window["change" + index])
            window["change" + index] = 0 if window["change" + index].toString().indexOf("-") isnt -1
            monTarget[a.stat] = eval(monTarget[a.stat] + a.modifier + window["change" + index])
            window["change" + index] = a.modifier + window["change" + index]
          else if a.modifier is "-" and (a.targeta is "targetenemy" or a.targeta is "aoeenemy") 
            if monster.passive
              passive = monster.passive
              if passive.targeta is "resist-penetration"
                if passive.stat is "spe_resist" and parseInt(monTarget["spe_resist"]) > 0
                  bonus = 1 + passive.change/100
                  window["change" + index] = 
                    eval(a.change * a.scaling * bonus * fatigue_effect - monTarget["spe_resist"])
            else
              window["change" + index] = 
                eval(a.change * a.scaling * fatigue_effect - monTarget["spe_resist"])
            window["change" + index] = Math.round(window["change" + index])
            window["change" + index] = 0 if window["change" + index].toString().indexOf("-") isnt -1
            monTarget[a.stat] = eval(monTarget[a.stat] + a.modifier + window["change" + index])
            window["change" + index] = a.modifier + window["change" + index]
          else
            window["change" + index] = a.change * a.scaling * fatigue_effect
            window["change" + index] = Math.round(window["change" + index])
            monTarget[a.stat] = eval(monTarget[a.stat] + a.modifier + window["change" + index])
            window["change" + index] = a.modifier + window["change" + index]
            monTarget.isAlive() if typeof monTarget.isAlive isnt "undefined"
        i++
      if ability.effects.length isnt 0 ####################################################### Effect activation from ability
        i = 0
        while i < ability.effects.length
          effect = a.effects[i]
          switch effect.targeta
            when "taunt", "poison-hp", "timed-phy-resist-buff", "timed-phy-resist-debuff"
                  , "timed-spe-resist-buff", "timed-spe-resist-debuff", "shield", "aoe-curse"
                  , "help-curse", "atk-curse"
              real_targets = []
              index = 0
              while index < abilitytargets.length
                if abilitytargets[index].passive
                  if abilitytargets[index].passive.targeta isnt effect.targeta
                    real_targets.push(abilitytargets[index])
                else
                  real_targets.push(abilitytargets[index])
                index++
              effect.activate real_targets
            when "timed-atk-buff"
              teamAttackAbilities = []
              index1 = 0 
              n = abilitytargets.length
              while index1 < n 
                teamAttackAbilities.push(abilitytargets[index1].abilities[0])
                index1++
              effect.activate teamAttackAbilities
            when "timed-spe-buff"
              teamSpecialAbilities = []
              index2 = 0 
              n = abilitytargets.length
              while index2 < n 
                teamAttackAbilities.push(abilitytargets[index2].abilities[1])
                index2++
              effect.activate teamSpecialAbilities
            when "self", "self-poison-hp", "self-timed-phy-resist-debuff"
                  , "self-timed-spe-resist-debuff"
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
              index3 = 0
              while index3 < abilitytargets.length
                index = getRandom([0,1,2,3])
                effectTargets.push abilitytargets[index3].abilities[index]
                index3++
              effect.activate effectTargets
            when "ap-overload"
              effect.activate [battle.players[0]]
            when "tworandomallies"
              effectTargets = []
              findAliveFriends()
              effectTargets.push liveFriends[0]
              effectTargets.push liveFriends[1] if typeof liveFriends[1] isnt "undefined"
              effect.activate effectTargets
          i++
######################################################################################################### Effect logics
    $(ability.effects).each ->
      effect = @
      if effect.duration isnt 0 and effect.targeta.indexOf("poison") is -1
        effect.duration += 1 if monster.team is 1 
      @monDex = monster.index 
      @teamDex = monster.team
      @name = @name.replace(/\s+/g, '')
      @activate = (effectTargets) ->
        fatigue_effect = 1 - monster.fatigue*0.1
        e = this
        i = 0
        if e.targeta.indexOf("curse") isnt -1 
          while i < effectTargets.length
            monTarget = effectTargets[i]
            if monTarget.isAlive()
              findObjectInArray(monTarget.cursed, "targeta", e.targeta)
              if usefulArray.length isnt 0 
                status = Object.create(e)
                status.change = eval(status.change * fatigue_effect)
                monTarget.cursed.push(status)
                addEffectIcon(monTarget, e, fatigue_effect)
              else
                status = Object.create(e)
                status.change = eval(status.change * fatigue_effect)
                usefulArray[0] = status
                removeEffectIcon(monTarget, e)
                addEffectIcon(monTarget, e, fatigue_effect)
            i++
        else if e.targeta.indexOf("shield") isnt -1
          while i < effectTargets.length
            monTarget = effectTargets[i]
            if monTarget.isAlive()
              if monTarget.shield.end is undefined
                addEffectIcon(monTarget, e, fatigue_effect)
              else 
                monTarget[e.stat] = eval(monTarget[e.stat] + e.restore)
                monTarget["max_hp"] = eval(monTarget["max_hp"] + e.restore) if monTarget.hp > 0
                removeEffectIcon(monTarget, e)
                addEffectIcon(monTarget, e, fatigue_effect)
              monTarget[e.stat] = 
                eval(monTarget[e.stat] + e.modifier + e.change * fatigue_effect)
              monTarget["max_hp"] = 
                eval(monTarget["max_hp"] + e.modifier + e.change * fatigue_effect) if monTarget.hp > 0
              monTarget.shield.name = e.name
              monTarget.shield.restore = e.restore
              monTarget.shield.targeta = e.targeta
              monTarget.shield.extra_hp = e.change * fatigue_effect
              monTarget.shield.description = e.description
              monTarget.shield.end = battle.round + e.duration
              monTarget.shield.old_hp = monTarget.hp
            i++
        else if e.targeta.indexOf("taunt") isnt -1
          while i < effectTargets.length
            monTarget = effectTargets[i]
            if monTarget.isAlive()
              if monTarget.taunted.end is undefined
                addEffectIcon(monTarget, e, fatigue_effect)
              else 
                removeEffectIcon(monTarget, e)
                addEffectIcon(monTarget, e, fatigue_effect)
              monTarget.taunted.description = e.description
              monTarget.taunted.targeta = e.targeta
              monTarget.taunted.target = monster.index
              monTarget.taunted.end = battle.round + e.duration
            i++
        else if e.targeta.indexOf("poison") isnt -1
          while i < effectTargets.length
            monTarget = effectTargets[i]
            monTarget[e.stat] = 
              eval(monTarget[e.stat] + e.modifier + e.change * fatigue_effect)
            window["change" + monTarget.unidex] = 
              eval(window["change" + monTarget.unidex] + e.modifier + e.change * fatigue_effect)
            if monTarget.shield.end isnt "undefined"
              monTarget.shield.true_damage += parseInt(e.change * fatigue_effect) 
            checkMax()
            monTarget.isAlive() if typeof monTarget.isAlive isnt "undefined"
            if monTarget.isAlive()
              findObjectInArray(monTarget.poisoned, "targeta", e.targeta)
              if usefulArray.length is 0
                status = {}
                status["name"] = e.name
                status["stat"] = e.stat
                status["impact"] = e.modifier + e.change * fatigue_effect
                status["change"] = e.change * fatigue_effect
                status["targeta"] = e.targeta
                status["end"] = battle.round + e.duration
                monTarget.poisoned.push(status)
                addEffectIcon(monTarget, e, fatigue_effect)
              else
                old_effect = usefulArray[0]
                removeEffectIcon(monTarget, old_effect)
                addEffectIcon(monTarget, e, fatigue_effect)
                old_effect.description = e.description
                old_effect.impact = e.modifier + e.change * fatigue_effect
                old_effect.change = e.change * fatigue_effect
                old_effect.end = battle.round + e.duration
            i++
        else if e.targeta.indexOf("timed") isnt -1
          while i < effectTargets.length
            monTarget = effectTargets[i]
            object = undefined
            if monTarget.type is "ability" 
              object = battle.players[monTarget.team].mons[monTarget.index]
              findObjectInArray(object.weakened, "targeta", e.targeta)
            else
              findObjectInArray(monTarget.weakened, "targeta", e.targeta)
            if monTarget.isAlive()
              if usefulArray.length is 0
                monTarget[e.stat] = 
                  eval(monTarget[e.stat] + e.modifier + e.change * fatigue_effect)
                status = {}
                status["description"] = e.description
                status["stat"] = e.stat
                status["restore"] = e.restore * fatigue_effect
                status["end"] = battle.round + e.duration
                status["targeta"] = e.targeta
                status["change"] = e.modifier 
                if object is undefined
                  monTarget.weakened.push(status)
                else 
                  object.weakened.push(status)
                addEffectIcon(monTarget, e, fatigue_effect)
              else 
                old_effect = Object.create(usefulArray[0])
                monTarget[old_effect.stat] = eval(monTarget[old_effect.stat] + old_effect.restore)
                usefulArray[0]["description"] = e.description
                usefulArray[0]["stat"] = e.stat
                usefulArray[0]["restore"] = e.restore * fatigue_effect
                usefulArray[0]["end"] = battle.round + e.duration
                monTarget[e.stat] = eval(monTarget[e.stat] + e.modifier + e.change * fatigue_effect)
                removeEffectIcon(monTarget, e)
                addEffectIcon(monTarget, e, fatigue_effect)
            i++
        else
          while i < effectTargets.length
            monTarget = effectTargets[i]
            if e.targeta isnt "ap-overload"
              addEffectIcon(monTarget, e, fatigue_effect)
              setTimeout (->
                $(".effect").trigger("mouseleave")
                massRemoveEffectIcon(e)
              ), 1500
            impact = Math.round(e.change * fatigue_effect)
            monTarget[e.stat] = eval(monTarget[e.stat] + e.modifier + impact)
            window["change" + monTarget.unidex] = 
              eval(window["change" + monTarget.unidex] + e.modifier + e.change * fatigue_effect)
            window["change" + monTarget.unidex] = Math.round(window["change" + monTarget.unidex])
            if (window["change" + monTarget.unidex].toString().indexOf "-" is -1 or 
                window["change" + monTarget.unidex].toString().indexOf "+" is -1) and
                parseInt(window["change" + monTarget.unidex]) > 0 
              window["change" + monTarget.unidex] = "+" + window["change" + monTarget.unidex].toString()
            checkMax()
            monTarget.isAlive() if typeof monTarget.isAlive isnt "undefined"
            i++



################################################################################################################ General Logic helpers
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
  return liveFoes

window.findAliveFriends = ->
  window.liveFriends = []
  n = playerMonNum
  i = 0
  while i < n
    if battle.players[0].mons[i].isAlive() is true
      liveFriends.push battle.players[0].mons[i]
    i++
  shuffle(liveFriends)
  return liveFriends

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
window.setFatigue = ->
  i = 0 
  while i < playerMonNum
    width = battle.players[0].mons[i].fatigue/10*100.toString() + "%"
    $(".user .mon"  + i + " " + ".faitgue-bar-for-real").css("width", width)
    if battle.players[0].mons[i].fatigue > 5
      $(".user .mon"  + i + " " + ".faitgue-bar-for-real").
        attr("src", "https://s3-us-west-2.amazonaws.com/monbattle/images/Red-Ap-1px.gif")
    else
      $(".user .mon"  + i + " " + ".faitgue-bar-for-real").
        attr("src", "https://s3-us-west-2.amazonaws.com/monbattle/images/Yellow-Ap-1px.gif")
    i++

window.availableAbilities = () ->
  if $(".oracle-skill-icon").data("apcost") > battle.players[0].ap or battle.summonerCooldown isnt 0
    $(".oracle-skill-icon").css("opacity", "0.5")
    $(".oracle-skill-icon").css("cursor", "default")
    document.getElementsByClassName("oracle-skill-icon")[0].style.pointerEvents = "none"
  else 
    $(".oracle-skill-icon").css("cursor", "pointer")
    $(".oracle-skill-icon").css("opacity", "1")
    document.getElementsByClassName("oracle-skill-icon")[0].style.pointerEvents = "auto"
  $(".availability-arrow").each ->
    arrow = $(this)
    $(this).data("available", "false") 
    $(this).last().parent().children(".monBut").children("button").each ->
      button = $(this)
      if $(this).css("opacity") isnt "0"
        if $(this).data("apcost") > battle.players[0].ap
          $(button).css("opacity", "0.5")
          if $(button).data("target") is "evolve"
            $(button).children(".but-image").
              attr("src", "https://s3-us-west-2.amazonaws.com/monbattle/images/ascend_idle.svg")
        else 
          $(button).css("opacity", "1")
          $(button).parent().parent().children(".availability-arrow").data("available", "true")
          if $(button).data("target") is "evolve"
            $(button).children(".but-image").
              attr("src", "https://s3-us-west-2.amazonaws.com/monbattle/images/ascend_turning.svg")
    if $(arrow).data("available") is "true" && 
        battle.players[0].mons[$(arrow).data("index")].fatigue isnt 10
      $(arrow).css({"opacity":"1", "visibility":"visible"})
    else
      $(arrow).css({"opacity":"0", "visibility":"hidden"})
  if battle.players[0].ap >= battle.apGainCost
    $(".gain-ap").attr("src", "https://s3-us-west-2.amazonaws.com/monbattle/images/plus-button-v3.svg")
    $(".gain-ap").css("opacity", "1")
    document.getElementById("gain-ap").style.pointerEvents = "auto"
  else 
    setTimeout (->
      $(".gain-ap").css("opacity", "0")
    ), 250
    document.getElementById("gain-ap").style.pointerEvents = "none"

window.callAbilityImg = ->
  battle.players[targets[0]].mons[targets[1]].abilities[targets[2]].img

window.barChange = (current, max) ->
  "width": (current/max*100).toString() + "%"

window.apNum = ".ap .ap-number"

window.apBar = ".ap-meter .bar"

window.apInfo = (maxAP) ->
  maxAP + " / " + maxAP

window.apAfterUse = (current, max) ->
  current + " / " + max

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
  damage = Math.round(damage)
  if damage.toString().indexOf("-") is -1 and damage.toString().indexOf("+") is -1
    damage = "+" + damage.toString()
  damage_num = parseInt(damage)
  damage_num = damage_num * -1 if damage_num < 0 
  font_size = undefined
  if damage_num <= 200
    font_size = "150%"
  else if damage_num <= 500
    font_size = "200%"
  else if damage_num > 500
    font_size = "250%"
  $("." + team + " " + ".mon" + target + " " + "p.dam").text(damage).
    css({"color":color, "font-weight":"bold", "font-size":font_size}, 1).
    fadeIn(1).animate({"top":"-=50px", "z-index":"+=10000"}, 200).effect("bounce", {times: 10}).fadeOut().
    animate
      "top":"+=50px"
      "z-index":"-=10000"
      , 5

window.showDamageSingle = ->
  damageBoxAnime(enemyHurt.team, enemyHurt.index, window["change" + enemyHurt.unidex], "rgba(255, 0, 0)")

window.showDamageSingleVariable = (team, monster, modifier, impact) ->
  setTimeout (->
    if battle.players[team].mons[monster].hp > 0
      damageBoxAnime(team, monster, modifier + impact, "rgba(255, 0, 0)") 
  ), 1600

window.showHealSingle = ->
  damageBoxAnime(allyHealed.team, allyHealed.index, ability.modifier + window["change" + allyHealed.index], "rgba(50,205,50)")

window.showDamageTeam = (index) ->
  i = undefined
  n = undefined
  n = battle.players[index].mons.length
  i = 0
  while i < n
    unidex = battle.players[index].mons[i].unidex
    if parseInt($("." + index + " " + ".mon" + i + " " + ".current-hp").text()) > 0 and 
        parseInt(window["change" + unidex]) isnt 0 and parseInt(window["change" + unidex]) isnt -0
      if window["change"+unidex].toString().indexOf("-") isnt -1 
        if index is 1
          $(".total-damage-per-turn, .hits-per-turn").removeClass("magictime vanishOut")
          $(".total-damage-per-turn, .hits-per-turn").css({"opacity":"1", "z-index":"10000"})
          hits = parseInt($(".hits-per-turn .stupid-number").text())
          number = parseInt($(".total-damage-per-turn .stupid-number").text())
          number += (window["change" + unidex]*-1)
          hits += 1
          $(".hits-per-turn .stupid-number").text(hits)
          $(".total-damage-per-turn .stupid-number").text(number)
          $(".stupid-number").addClass("bigger") 
          if hits > 16 and $(".hits-per-turn .stupid-number").attr("class").indexOf("bigged") is -1
            $(".hits-per-turn").addClass("highHits")
            $(".hits-per-turn .stupid-number").css("font-size","400%").toggleClass("bigged")
          else if hits > 8 and $(".hits-per-turn .stupid-number").attr("class").indexOf("bigged") is -1
            $(".hits-per-turn").addClass("highHits")
            $(".hits-per-turn .stupid-number").css("font-size","300%").toggleClass("bigged")   
          if number > 2000 and $(".total-damage-per-turn .stupid-number").attr("class").indexOf("bigged") is -1
            $(".total-damage-per-turn").addClass("highDam")
            $(".total-damage-per-turn .stupid-number").css("font-size","400%").toggleClass("bigged")
          else if number > 1000 and $(".total-damage-per-turn .stupid-number").attr("class").indexOf("bigged") is -1
            $(".total-damage-per-turn").addClass("highDam")
            $(".total-damage-per-turn .stupid-number").css("font-size","300%").toggleClass("bigged")
          setTimeout (->
            $(".stupid-number").removeClass("bigger")
            $(".total-damage-per-turn, .hits-per-turn").addClass("magictime vanishOut")
          ), 1000
          setTimeout (->
            $(".total-damage-per-turn, .hits-per-turn").css({"z-index":"-1000", "opacity":"0"})
            $(".total-damage-per-turn, .hits-per-turn").removeClass("magictime vanishOut")
          ), 1750
        damageBoxAnime(index, i, window["change" + unidex], "rgba(255, 0, 0)")
      else 
        damageBoxAnime(index, i, window["change" + unidex], "rgba(50, 205, 50)")
      window["change"+unidex] = 0
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

window.addEffectIcon = (monster, effect, fatigue_effect) -> 
  e = Object.create(effect)
  e.target = battle.players[effect.teamDex].mons[effect.monDex].name if effect.targeta is "taunt"
  e.enemyDex = monster.team
  e.enemyMonDex = monster.index
  e.change = eval(e.change * fatigue_effect)
  e.end = effect.duration + battle.round
  effectBin.push(e)
  index = effectBin.indexOf(e)
  if index is 0
    setTimeout (->
      hopscotch.startTour(first_effect_tour) if $(".battle").data("battlecount") is 1
    ), 500
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
    $(document).off "click.cutscene", "#overlay"
  ), 2000
  setTimeout (->
    $("#overlay").fadeOut 500, ->
      window.battleTimer = setInterval(increaseTime, 1000)
      toggleImg()
      # $(".battle-message").show(500).effect("highlight", 500).fadeOut(300)
      # $(".enemy .img.mon-battle-image").each ->
      #   $(this).addClass("magictime tinLeftIn")
      setTimeout (->
        $(".0.user.mon-slot").addClass("magictime vanishIn")
      ), 750
      setTimeout (->
        $(".0.user.mon-slot").css("opacity", "1")
        $(".0.user.mon-slot").removeClass("magictime vanishIn")
      ), 1750
      $(".enemy .img").each ->
        $(this).css("background", "rgba(255, 0, 0,0.5)")
      $(".foe-indication").addClass("bounceIn animated")
      setTimeout (->
        if $(".battle").data("battlecount") is 0
          hopscotch.startTour(first_battle_tour) 
        else if $(".battle").data("levelname") is "Area A - Stage 1"
          hopscotch.startTour(ap_gain_tour)
        else if $(".battle").data("showoracleskill") is false
          hopscotch.startTour(fatigue_tour)
        else if $(".battle").data("oracleskillturtorial") is true
          hopscotch.startTour(oracle_skill_tour)
        # hopscotch.startTour(first_replay_tour) if $(".battle").data("bonusturtorial") is true
        $(".foe-indication").removeClass("bounceIn animated")
        $(".foe-indication").css("opacity", "0")
        document.getElementById('gain-ap').style.pointerEvents = 'auto'
        document.getElementById('end-turn-tip').style.pointerEvents = 'auto'
        $(".enemy .img").each ->
          $(this).css("background", "transparent")
      ), 1750
    ), time
  # setTimeout (->
  #   $("#battle-tutorial").joyride({'tipLocation': 'top'})
  #   $("#battle-tutorial").joyride({})
  #   toggleImg()
  # ), (time + 1500)


################################################################################################# Battle outcome helpers
window.checkOutcome = ->
  if battle.players[0].mons.every(isTeamDead) is true or battle.players[1].mons.every(isTeamDead) is true
    window.clearInterval(battleTimer)
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
    ), 1000

window.outcome = ->
  muted = undefined
  outcome_url = undefined
  cutscene_field = undefined
  cutscene_length = undefined
  victor = undefined
  loser = undefined
  endgame_box = undefined
  if $(".battle-music").prop("muted") is true
    muted = true
  else 
    muted = false
  if battle.players[0].mons.every(isTeamDead) or battle.players[1].mons.every(isTeamDead)
    if battle.players[0].mons.every(isTeamDead)
      cutscene_field = "defeat_cut_scenes"
      cutscene_length = battle[cutscene_field].length
      outcome_url = "/loss"
      victor = battle.players[1].username
      loser = battle.players[0].username
      endgame_box = ".end-battle-box.loser"
    else
      cutscene_field = "end_cut_scenes"
      cutscene_length = battle[cutscene_field].length
      outcome_url = "/win"
      victor = battle.players[0].username
      loser = battle.players[1].username
      endgame_box = ".end-battle-box.winning"
    $(".next-scene").css("top", "10px")
    $.ajax
      url: "/battles/" + battle.id + outcome_url
      method: "get"
      data: {round_taken: parseInt(battle.round), "muted": muted},
      success: (response) ->
        setTimeout (->
          $.ajax
            url: "/battles/" + battle.id
            method: "patch"
            data: {
              "victor": victor,
              "loser": loser,
              "round_taken": parseInt(battle.round),
              "time_taken": parseInt(seconds_taken)
            }
        ), 750
        $(".message").html(response)
        $(".share-but").on "click", ->
          caption = document.getElementsByClassName("username")[0].innerHTML + " is playing monbattle!"
          name = $(".end-battle-box.winning").data("share")
          picture_url = "https://s3-us-west-2.amazonaws.com/monbattle/notices/banners/000/000/010/cool/monbattle-site-banner-175.png?1424723470"
          sendBrag caption, picture_url, name, ->
            showHome()
            return
        if battle.players[1].mons.every(isTeamDead)
          if $(".ability-earned").data("type") is "ability"
            sentence = "You have earned " + $(".ability-earned").text() + 
                       "! Teach it to your monster through the " + 
                       "<a href='/learn_ability'>Ability Learning</a>" + " page!" 
            newAbilities.push(sentence) if $(".ability-earned").data("firsttime") is true
          else if $(".ability-earned").data("type") is "monster"
            sentence = "You have earned " + $(".ability-earned").text() +
                       "! Add it to your team at the " +
                       "<a href='/home'>Edit Team</a>" + " page!"
            newMonsters.push(sentence)
    toggleImg()
    document.getElementById('battle').style.pointerEvents = 'none'
    $(document).on "click.cutscene", "#overlay", ->
      if $(".cutscene").attr("src") is battle[cutscene_field][cutscene_length-1] or 
          battle[cutscene_field].length is 0
        $(".cutscene").hide(500)
        endCutScene()
        setTimeout (->
          $(".next-scene, .cutscene, .skip-button").remove()
          $(endgame_box).css("z-index", "1000")
          $(endgame_box).removeClass("bounceIn animated")
          $(endgame_box).addClass("bounceIn animated")
          setTimeout (->
            endBattleTutorial()
          ), 1000
          if $(".level-up-box").length > 0
            document.getElementById('winning').style.pointerEvents = 'none'
            setTimeout (->
              $(".level-up-box").addClass("zoomInUp animated").css("opacity", "1")
            ), 1200
            setTimeout (->
              $(".level-up-box").addClass("zoomOutUp")
              setTimeout (->
                document.getElementById('winning').style.pointerEvents = 'auto'
              ), 1500
            ), 4200
        ), 750
      else 
        new_index = battle[cutscene_field].indexOf($(".cutscene").attr("src")) + 1
        window.new_scene = battle[cutscene_field][new_index]
        nextScene()
    if battle[cutscene_field].length isnt 0
      $(".next-scene").css("opacity", "0")
      $(".cutscene").attr("src", battle[cutscene_field][0])
      $(".cutscene").show()
      $(".cutscene").css("opacity", "1")
      setTimeout (->
        $("#overlay").fadeIn(500)
      ), 750
      nextSceneInitial()
    else 
      $(document).off "click.cutscene"
      $(".cutscene, .next-scene").css("opacity", "0")
      $("#overlay").fadeIn(1000)
      setTimeout (->
        $(".next-scene, .cutscene").remove()
        $(endgame_box).css("z-index", "1000")
        $(endgame_box).removeClass("bounceIn animated")
        $(endgame_box).addClass("bounceIn animated")
        setTimeout (->
          endBattleTutorial()
        ), 1000
        if $(".level-up-box").length isnt 0
          document.getElementById('winning').style.pointerEvents = 'none'
          setTimeout (->
            $(".level-up-box").addClass("zoomInUp animated").css("opacity", "1")
          ), 1200
          setTimeout (->
            $(".level-up-box").addClass("zoomOutUp")
            setTimeout (->
              document.getElementById('winning').style.pointerEvents = 'auto'
            ), 1500
          ), 4200
      ), 1800

################################################################################################### Display function-calling helpers
window.singleTargetAbilityAfterClickDisplay = (ability) ->
  # disable(ability)
  $(".img").css("background", "transparent")
  $(".enemy .mon-name").css("opacity", "0")
  offUserTargetClick()
  turnOff("click.boom", ".enemy")
  turnOff("click.help", ".user")
  $(".availability-arrow").each ->
    $(this).css("opacity", "0")
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
  $(".img.mon-battle-image").each ->
    $(this).css "background", "transparent"
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
  $(".availability-arrow").each ->
    $(this).css("opacity", "0")
  userTargetClick()
  $(".battle-guide.guide").text("Select an ally target to activate")
  $(".battle-guide").show()
  $(".battle-guide.cancel, .battle-guide").css("z-index", "15000")
  turnOffCommandA()
  toggleImg()

window.enemyAbilityBeforeClickDisplay = ->
  $(".availability-arrow").each ->
    $(this).css("opacity", "0")
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
window.setSummonerAbility = ->
  index = playerMonNum
  shuffle(battle.players[0].mons[index-1].abilities)
  ability = battle.players[0].mons[index-1].abilities[0]
  $(".oracle-skill-icon").fadeOut 400, ->
    $(".oracle-skill-icon").data("apcost", ability.ap_cost)
    $(".oracle-skill-icon").data("target", ability.targeta)
    $(".oracle-skill-icon").attr("src", ability.port)
    $(".oracle-skill-icon").fadeIn(400)
    if battle.summonerCooldown is 0
      $(".oracle-skill-icon").css({"opacity":"1", "cursor":"pointer"})
    else
      $(".oracle-skill-icon").css({"opacity":"0.5", "cursor":"default"})
    zetBut()


window.turnOnSummonerActions = ->
  $(document).on "click.ap-gain", ".gain-ap", ->
    if $(this).data("apcost") <= battle.players[0].ap
      $(".end-turn").css("opacity", "0.5")
      $(".end-turn, .ap-gain").prop("disabled", "true")
      xadBuk()
      battle.players[0].gainAp()
      $("#ap-tip").toggleClass("flip animated")
      apChange()
      setTimeout (->
        $(".end-turn").css("opacity", "1")
        $(".end-turn, .ap-gain").prop("disabled", "false")
        $("#ap-tip").toggleClass("flip animated")
        availableAbilities()
        zetBut()
        flashEndButton()
      ), 750
    else 
      alert("You don't have enough ap!")
  $(document).off "click.summoner_skill"
  $(document).on "click.summoner_skill", ".oracle-skill-icon", ->
    $(".big-ass-monster").attr("src","https://s3-us-west-2.amazonaws.com/monbattle/images/main+chars/oracle-cutscene.svg").
      addClass("oracle-skill-cutscene")
    if $(this).data("apcost") <= battle.players[0].ap and battle.summonerCooldown is 0
      setTimeout (->
        $("#animation-overlay").css({"opacity":"1", "z-index":"100000000000"})
        $(".big-ass-monster").addClass("fadeInRight animated")
      ), 400
      setTimeout (->
        $(".big-ass-monster").removeClass("fadeInRight animated").addClass("fadeOutLeft animated")
      ), 1400
      setTimeout (->
        $("#animation-overlay").css({"opacity":"0", "z-index":"-10"})
        $(".big-ass-monster").removeClass("fadeInRight fadeOutLeft animated")
      ), 2400
      setTimeout (->
        $(".big-ass-monster").removeClass("oracle-skill-cutscene")
        toggleImg()
        turnOffCommandA()
        $(".end-turn, .oracle-skill-icon").css("opacity", "0.5")
        $(".end-turn, .oracle-skill-icon").css("cursor","default")
        index = playerMonNum - 1
        controlAI(0, index, "", 0)
        setTimeout (->
          turnOnCommandA()
          toggleImg()
        ), 2000
        setTimeout (->
          $(".cooldown-box").css("opacity","1")
          $(".cooldown-count").text("2")
          apChange()
          flashEndButton()
        ), 2500
      ), 2500

window.userTargetClick = ->
  $(document).on("mouseover.friendly", ".user.mon-slot .img", ->
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
  ), 1500

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
    $(".next-scene").css("opacity", "0.8")
    if document.getElementById('overlay') isnt null
      document.getElementById('overlay').style.pointerEvents = 'auto'
  ), 2000

window.mouseOverMon = ->
  mon = $(this).closest(".mon").data("index")
  team = $(this).closest(".mon-slot").data("team")
  monster = battle.players[team].mons[mon]
  if $(this).css("opacity") isnt "0" and parseInt(monster.fatigue) isnt 10
    $(this).parent().children(".availability-arrow").css("visibility", "hidden")
    $(this).parent().children(".availability-arrow")
    $(this).parent().children(".img").addClass("controlling") 
    $(this).parent().children(".monBut").css("visibility", "visible")
    $(this).parent().children(".monBut").css({"opacity":"1", "z-index":"20000"})
    window.currentMon = $(this).parent().children(".img")
    window.targets = [
      team
      mon
    ]

window.mouseLeaveMon = ->
  $(".availability-arrow").css("visibility", "visible")
  $(".monBut").css("visibility", "hidden")
  $(".user .monBut").css({"opacity":"0", "z-index":"-1"})
  $(".user .img").removeClass("controlling")

window.turnOnCommandA = ->
  $(document).on "mouseleave.command", ".user.mon-slot .mon", mouseLeaveMon
  $(document).on "mouseover.command", ".user.mon-slot .img", mouseOverMon
  $(document).on "mousemove.command", ".user.mon-slot .img", mouseOverMon
  turnOnSummonerActions()

window.turnOffCommandA = ->
  $(document).off "mouseleave.command", ".user.mon-slot .mon"
  $(document).off "mouseover.command", ".user.mon-slot .img"
  $(document).off "mousemove.command", ".user.mon-slot .img"
  $(".gain-ap").css("pointer-events", "none")
  $(".oracle-skill-icon").css("cursor", "default")
  $(".oracle-skill-icon").css("opacity", "0.5")
  $(document).off "click.ap-gain", ".gain-ap"
  $(document).off "click.summoner_skill", ".oracle-skill-icon"

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
    $(".end-turn").css("cursor", "pointer")
  ), 500
  $(".monBut button").each ->
    if $(this).parent().parent().children(".img").css("opacity") isnt "0" && $(this).attr("disabled") isnt "disabled"
      buttonArray.push $(this)
  buttonArray.push($(".gain-ap")[0]) if $(".battle").data("levelname") isnt "First battle"
  if buttonArray.every(noApLeft) || buttonArray.every(nothingToDo)
    timer = undefined
    if deathAbilitiesToActivate["pc"].length isnt 0
      timer = 3000
    else
      timer = 1300
    setTimeout (->
      $(".end-turn").trigger("click") if $("#overlay").css("display") is "none"
      return
    ), timer
    return

window.toggleEnemyClick = ->
  $(".enemy .img.mon-battle-image").each ->
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
              window["change" + mon.unidex] = e.impact
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
              if e.targeta is "timed-atk-buff" or e.targeta is "random-timed-atk-buff"
                mon.abilities[0][e.stat] = eval(mon.abilities[0][e.stat] + e.restore)
              else if e.targeta is "timed-spe-buff" or e.targeta is "random-timed-spe-buff"
                mon.abilities[1][e.stat] = eval(mon.abilities[1][e.stat] + e.restore)
              else
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
    if battle.players[0].mons[i].hp/battle.players[0].mons[i].max_hp <= pct &&
        battle.players[0].mons[i].hp > 0 && battle.players[0].mons[i].type isnt "summoner"
      aiTargets.push battle.players[0].mons[i].index 
    i++
window.findTargetsAbovePct = (pct) ->
  i = undefined
  n = undefined
  n = playerMonNum
  i = 0
  window.aiTargets = []
  while i < n
    if battle.players[0].mons[i].hp/battle.players[0].mons[i].max_hp >= pct &&
        battle.players[0].mons[i].hp > 0 && battle.players[0].mons[i].type isnt "summoner"
      aiTargets.push battle.players[0].mons[i].index
    i++
window.findTargets = (hp) ->
  i = undefined
  n = undefined
  n = playerMonNum
  i = 0
  window.aiTargets = []
  while i < n
    if battle.players[0].mons[i].hp <= hp &&
        battle.players[0].mons[i].hp > 0 && battle.players[0].mons[i].type isnt "summoner"
      aiTargets.push battle.players[0].mons[i].index
    i++
window.totalUserHp = ->
  i = undefined
  n = undefined
  totalCurrentHp = 0
  n = playerMonNum
  i = 0
  while i < n
    totalCurrentHp += battle.players[0].mons[i].hp if battle.players[0].mons[i].type isnt "summoner"
    i++
  return totalCurrentHp
window.teamPct = ->
  totalMaxHp = 0
  n = playerMonNum
  i = 0
  while i < n
    totalMaxHp += battle.players[0].mons[i].max_hp if battle.players[0].mons[i].type isnt "summoner"
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

window.updateApAbilityCost = () ->
  battle.apGainCost = eval(battle.maxAP/2)
  cost = parseInt(battle.apGainCost)
  i = 0 
  while i < battle.players[0].mons.length
    if battle.players[0].mons[i].abilities[1].targeta is "action-point"
      battle.players[0].mons[i].abilities[1].ap_cost = cost/2
      $(".user " + ".mon" + i + " " + ".action.ability").data("apcost", cost/2) 
    i++
  $(".gain-ap").data("apcost", cost) 



############################################################################################################ AI logics
window.feedAiTargets = ->
  if battle.round <= 4
    window.aiAbilities = [0,1]
    findTargetsBelowPct(1)
  else if battle.round <= 7 && teamPct() <= 0.7
    window.aiAbilities = [0,2]
    findTargetsBelowPct(0.6)
    findTargetsBelowPct(0.9) if aiTargets.length is 0
    findTargetsBelowPct(1) if aiTargets.length is 0
  else if battle.round <= 7 && teamPct() > 0.7
    window.aiAbilities = [1,2] 
    findTargetsAbovePct(0.8)
    findTargetsAbovePct(0.6) if aiTargets.length is 0
    findTargetsBelowPct(1) if aiTargets.length is 0
  else if battle.round <= 10 && teamPct() <= 0.5
    window.aiAbilities = [1,2]
    findTargetsBelowPct(0.5)
    findTargetsBelowPct(0.75) if aiTargets.length is 0 
    findTargetsBelowPct(1) if aiTargets.length is 0
  else if battle.round <= 10 && teamPct() > 0.5
    window.aiAbilities = [2,3]
    findTargetsAbovePct(0.7)
    findTargetsAbovePct(0.5) if aiTargets.length is 0
    findTargetsBelowPct(1) if aiTargets.length is 0
  else if battle.round <= 13 && teamPct() > 0.5
    window.aiAbilities = [3]
    findTargetsAbovePct(0.5) 
    findTargetsAbovePct(0.2) if aiTargets.length is 0
    findTargetsBelowPct(1) if aiTargets.length is 0
  else if battle.round <= 13 && teamPct() <= 0.5
    window.aiAbilities = [1,2,3]
    findTargetsBelowPct(0.3)
    findTargetsBelowPct(0.7) if aiTargets.length is 0
    findTargetsBelowPct(1) if aiTargets.length is 0
  else if battle.round <= 16 && teamPct() > 0.4
    window.aiAbilities = [3]
    findTargetsAbovePct(0.4)
    findTargetsAbovePct(0.1) if aiTargets.length is 0
    findTargetsBelowPct(1) if aiTargets.length is 0
  else if battle.round <= 16 && teamPct() <= 0.4 
    window.aiAbilities = [0,2,3]
    findTargetsBelowPct(0.3)
    findTargetsBelowPct(0.7) if aiTargets.length is 0
    findTargetsBelowPct(1) if aiTargets.length is 0
  else if battle.round > 16
    window.aiAbilities = [2,3]
    findTargetsBelowPct(0.25)
    findTargetsBelowPct(0.6) if aiTargets.length is 0
    findTargetsBelowPct(1) if aiTargets.length is 0



################################################################################################ AI action helpers(not very dry)
window.controlAI = (teamIndex, monIndex, type, abilityDex) ->
  monster = battle.players[teamIndex].mons[monIndex]
  abilityIndex = undefined
  enemyTeamIndex = undefined
  if teamIndex is 0
    enemyTeamIndex = 1
  else
    enemyTeamIndex = 0
  if typeof monster isnt "undefined" 
    if monster.hp > 0 or type is "death" or monster.type is "summoner"
      # if teamIndex is 1 and type isnt "death" and monster.type isnt "summoner"
      #   $(".battle-message").text(
      #     monster.name + ":" + " " + getRandom(monster.speech)).
      #     effect("highlight", 500)
      if teamIndex is 1 and type isnt "death"
        abilityIndex = getRandom(aiAbilities)
        if monster.taunted.target is undefined 
          window.targetIndex = getRandom(aiTargets)
        else 
          if parseInt(battle.players[enemyTeamIndex].mons[monster.taunted.target].hp) > 0 
            window.targetIndex = monster.taunted.target 
      else 
        abilityIndex = abilityDex
      ability = battle.players[teamIndex].mons[monIndex].abilities[abilityIndex]
      if ability.targeta is "random-foe" or ability.targeta is "random-ally"
        if teamIndex is 0
          if ability.targeta is "random-foe"
            window.targetIndex = findAliveEnemies()[0].index
          else 
            window.targetIndex = findAliveFriends()[0].index
        else 
          if ability.targeta is "random-foe"
            window.targetIndex = findAliveFriends()[0].index
          else 
            window.targetIndex = findAliveEnemies()[0].index
      switch ability.targeta
        when "attack"
          window.targets = [1].concat [monIndex, abilityIndex, targetIndex]
          currentMon = pcMon(monIndex)
          currentPosition = currentMon.offset()
          targetMon = userMon(targetIndex)
          targetPosition = targetMon.offset()
          backPosition = currentMon.position()
          topMove = targetPosition.top - currentPosition.top
          leftMove = targetPosition.left - currentPosition.left - 44
          action()
          singleTargetAbilityDisplayVariable()
          $(".single-ability-img").finish().css(targetPosition)
          currentMon.finish().animate(
            "left": "+=" + leftMove.toString() + "px"
            "top": "+=" + topMove.toString() + "px"
          , 540)
          setTimeout (->
            $(".single-ability-img").css({"visibility":"visible","z-index":"1000"})
            .attr("src", "https://s3-us-west-2.amazonaws.com/monbattle/images/big-spark.gif")
            if targetMon.css("display") isnt "none"
              if enemyHurt.isAlive() is false
                targetMon.effect("explode", {pieces: 30}, 1000).hide()
              else
                targetMon.finish().animate(left: "+=60px", 200)
            currentMon.finish().animate backPosition, 540
            ), 560
          setTimeout (->
            targetMon.finish().animate(left: "-=60px", 700)
            $(".single-ability-img").css({"visibility":"hidden","z-index":"-1"}).attr("src","")
            showDamageTeam(0)
            showDamageTeam(1)
            hpChangeBattle()
            checkMonHealthAfterEffect()
            ), 1100
        when "targetenemy", "random-foe"
          window.targets = [teamIndex].concat [monIndex, abilityIndex, targetIndex]
          currentMon = $(".enemy .mon" + monIndex + " " + ".img")
          if teamIndex is 1
            currentMon.effect("bounce", {distance: 50, times: 1}, 800)
          targetMon = undefined
          if teamIndex is 1
            targetMon = userMon(targetIndex)
          else
            targetMon = pcMon(targetIndex)
          targetPosition = targetMon.offset()
          abilityAnime = $(".single-ability-img")
          singleTargetAbilityDisplayVariable()
          abilityAnime.css(targetPosition)
          abilityAnime.finish().attr("src", callAbilityImg).toggleClass "flipped ability-on", ->
            action()
            if targetMon.css("display") isnt "none"
              if enemyHurt.isAlive() is false
                if teamIndex is 1
                  setTimeout (->
                    targetMon.effect("explode", {pieces: 30}, 1000).hide()
                  ), 1000
                else 
                  setTimeout (->
                    targetMon.css("transform":"scaleX(-1)").effect("explode", {pieces: 30}, 1000).hide()
                  ), 1000
              else
                targetMon.effect "shake", times: 10, 750
            element = $(this)
            setTimeout (->
              showDamageTeam(0)
              showDamageTeam(1)
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
          if teamIndex is 1 and ability.rarita isnt "death-passive"
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
              $(".user.mon-slot .img").each ->
                if $(this).parent().children(".img.mon-battle-image").css("display") isnt "none"
                  if battle.players[0].mons[$(this).data("index")].isAlive() is false
                    $(this).effect("explode", {pieces: 30}, 1200).hide()
                  else
                    $(this).effect "shake", {times: 5, distance: 40}, 750
            else 
              $(".enemy.mon-slot .img").each ->
                if $(this).parent().children(".img.mon-battle-image").css("display") isnt "none"
                  if battle.players[1].mons[$(this).data("index")].isAlive() is false
                    $(this).css("transform":"scaleX(-1)").effect("explode", {pieces: 30}, 1200).hide()
                  else
                    $(this).effect "shake", {times: 5, distance: 40}, 750
            setTimeout (->
              element.toggleClass "flipped ability-on"
              element.toggleClass aoePosition
              element.attr("src", "")
              showDamageTeam(0)
              showDamageTeam(1)
              hpChangeBattle()
              checkMonHealthAfterEffect()            
              return
            ), 1500
            return
        when "aoeally", "aoecleanse"
          window.targets = [teamIndex].concat [monIndex, abilityIndex]
          if teamIndex is 1
            currentMon = $(".enemy .mon" + monIndex + " " + ".img")
            currentMon.effect("bounce", {distance: 50, times: 1}, 800)
          aoePosition = undefined
          if teamIndex is 0
            aoePosition = "aoePositionUser"
          else
            aoePosition = "aoePositionFoe"
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
              showDamageTeam(0)
              showDamageTeam(1)
              hpChangeBattle()
              checkMonHealthAfterEffect()
              return
            ), 1200
            return
        when "targetally", "random-ally"
          index = minimumHpPC()
          if teamIndex is 1
            window.targets = [teamIndex].concat [monIndex, abilityIndex, index]
          else 
            window.targets = [teamIndex].concat [monIndex, abilityIndex, targetIndex]
          currentMon = $(".enemy .mon" + monIndex + " " + ".img")
          if teamIndex is 1
            currentMon.effect("bounce", {distance: 50, times: 1}, 800)
          if teamIndex is 1
            targetMon = pcMon(index)
          else 
            targetMon = userMon(targetIndex)
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
              showDamageTeam(0)
              showDamageTeam(1)
              element.toggleClass "ability-on"
              element.attr("src", "")
              hpChangeBattle()
              checkMonHealthAfterEffect()            
            ), 1200

############################################################################################################### AI action happening
window.ai = ->
  xadBuk()
  $(".total-damage-per-turn").css("opacity", "0")
  setTimeout (->
    $(".total-damage-per-turn").removeClass("highDam bigged").css("font-size","100%")
    $(".total-damage-per-turn .stupid-number").removeClass(".tada .animated bigged").text("0")
    $(".hits-per-turn").removeClass("highHits bigged").css("font-size","100%")
    $(".hits-per-turn .stupid-number").text("0").removeClass("bigged")
  ), 400
  $(".availability-arrow").each ->
    $(this).css("opacity", "0")
  $(".img").removeClass("controlling")
  $(".monBut").css("visibility", "hidden")
  $(".enemy .img").attr("disabled", "true")
  # $(".battle-message").fadeIn(1)
  battle.players[0].ap = 0
  battle.players[0].turn = false
  battle.players[1].ap = 1000000000000000
  enemyTimer()
  zetBut()
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
      $(".cooldown-box .cooldown-count").text(battle.summonerCooldown)
      if battle.summonerCooldown == 0
        $(".cooldown-box").css("opacity","0")
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
      healthRegen(0)
      healthRegen(1)
      checkMax()
      showDamageTeam(0)
      showDamageTeam(1)
      passiveScalingTeam(0, "round")
      passiveScalingTeam(1, "round")
      checkMonHealthAfterEffect()
      updateAbilityScaling(0, "missing-hp")
      updateAbilityScaling(1, "missing-hp")
      hpChangeBattle()
      $(".battle-message").fadeOut(100)
      $(".enemy .img").removeAttr("disabled")
      zetBut()
      toggleEnemyClick()
      $(".monBut button").trigger("mouseleave")
      setTimeout (->
        deathAbilitiesActivation("user")
      ), 800
      timeout = undefined
      if deathAbilitiesToActivate["user"].length isnt 0 
        timeout = deathAbilitiesToActivate["user"].length*3400 + 2600
      else 
        timeout = 500
      setTimeout (->
        checkOutcome() if $("#overlay").css("display") is "none"
        battle.players[0].ap -= battle.players[0].ap_overload
        battle.players[0].ap_overload = 0
        toggleImg()
        deathAbilitiesToActivate["user"].length = 0
        zetBut()
        setTimeout (->
          setSummonerAbility()
        ), 250
        setTimeout (->
          updateApAbilityCost()
          setFatigue()
          turnOnCommandA()
          apChange()
          $(".ap").effect("highlight")
          enable($("button"))
        ), 500
        setTimeout (->
          availableAbilities()
        ), 700
        setTimeout (->
          availableAbilities()
        ), 1000
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
    checkOutcome()
  ), 250
  setTimeout (->
    setFatigue()
    zetBut() if $("#overlay").css("display") is "none"
  ), 400


window.multipleAction = ->
  xadBuk()
  battle.monAbility(targets[0], targets[1], targets[2])
  fixHp()
  checkMax()
  updateAbilityScaling(0, "missing-hp")
  updateAbilityScaling(1, "missing-hp")
  setTimeout (->
    checkOutcome()
  ), 250
  setTimeout (->
    setFatigue()
    zetBut() if $("#overlay").css("display") is "none"
  ), 400

# window.controlAI = (teamIndex, monIndex, type, abilityDex)

window.activateDeathAbility = (team, index) ->
  ability = deathAbilitiesToActivate[team][index]
  $("." + ability.team + " " + ".mon" + ability.index + " " + ".img.passive").
    effect("explode", {pieces: 30}, 550).remove()
  if team is "user"
    setTimeout (->
      if $("#overlay").css("display") is "none"
        controlAI(ability.team, ability.index, "death", 2) 
    ), 800
  else 
    setTimeout (->
      if $("#overlay").css("display") is "none"
        controlAI(ability.team, ability.index, "death", 4)
    ), 800

window.deathAbilitiesActivation = (team) ->
  if deathAbilitiesToActivate[team].length isnt 0
    i = 0
    while i < deathAbilitiesToActivate[team].length
      ability = deathAbilitiesToActivate[team][i]
      delete battle.players[ability.team].mons[ability.index].passive_ability
      i++
    if $("#overlay").css("display") is "none"
      zetBut()
      setTimeout (->
        activateDeathAbility(team, 0) if $("#overlay").css("display") is "none"
      ), 250
      if deathAbilitiesToActivate[team].length is 2
        setTimeout (->
          activateDeathAbility(team, 1) if $("#overlay").css("display") is "none"
        ), 3500
      if deathAbilitiesToActivate[team].length is 3
        setTimeout (->
          activateDeathAbility(team, 2) if $("#overlay").css("display") is "none"
        ), 6750



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


window.healthRegen = (teamIndex) ->
  mons = battle.players[teamIndex].mons
  i = 0
  while i < mons.length
    passive = mons[i].passive_ability
    if mons[i].passive_ability
      if passive.targeta is "health-regen"
        mons[i]["hp"] += parseInt(passive.change)
        window["change" + mons[i].unidex] = 
          eval(window["change" + mons[i].unidex] + "+" + passive.change)
        if window["change" + mons[i].unidex].indexOf("-") is -1
          window["change" + mons[i].unidex] = 
            "+" + window["change" + mons[i].unidex].toString()
    i++


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
  $(".0.user.mon-slot").css("opacity","0")
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
################################################################################################# Surrender actions and Feature hiding
  if document.getElementById("battle") isnt null
    if $(".battle").data("showapbutton") is false
      $(".gain-ap").css("visibility", "hidden")
      $("#ap-tip").css({"width":"200px", "left":"63.7%"})
    if $(".battle").data("showoracleskill") is false
      $(".oracle-skill-panel").css("visibility", "hidden")
      $("#ap-tip").css("height", "50px")
    $("a.fb-nav, .logo-link, .top-bar").not(".quest-show, .mon-tab").on "click.leave", (event) ->
      $(".cutscene").css("opacity", "0")
      $(document).off "click.cutscene", "#overlay"
      nav = $(this)
      link = $(this).attr("href")
      text = $(this).text()
      if text isnt "Forum" 
        event.preventDefault()
        $(".confirmation").css({"opacity":"1", "z-index":"10000000"})
        $(".skip-button").css("opacity", "0")
        $(".leave-battle-but").attr("href", link)
        $("#overlay").fadeIn()
    $(".back-to-battle-but").on "click.back", (event) ->
      event.preventDefault()
      $("#overlay").fadeOut()
      $(".confirmation").css({"opacity":"0", "z-index":"-1"})
      setTimeout (->
        $(".skip-button").css("opacity", "1")
        $(".cutscene").css("opacity", "1")
      ), 500
################################################################################################ Ultimate ajax call
    $.ajax 
      url: "/battles/" + $(".battle").data("index") + ".json"
      dataType: "json"
      method: "get"
      error: ->
        alert("This battle cannot be loaded!")
      success: (data) ->
        document.getElementsByClassName("flash-store")[0].innerHTML = ""
        $(".navbar.mon-front").hide()
        window.battle = data
        window.seconds_taken = 0
        document.getElementById('gain-ap').style.pointerEvents = 'none'
        document.getElementById('end-turn-tip').style.pointerEvents = 'none'
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
            setTimeout (->
              zetBut()
            ), 200
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
        battle.totalTurnDamage = 0
        battle.apGainCost = 20
        battle.round = 0
        battle.maxAP = 40
        battle.summonerCooldown = 0
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
            battle.summonerCooldown -= 1 if battle.summonerCooldown isnt 0
            setAll(battle.players, "turn", true)
            setAll(battle.players, "ap", battle.maxAP)
            i = 0
            while i < playerMonNum
              if battle.players[0].mons[i].used is false
                battle.players[0].mons[i].fatigue -= 2
                if battle.players[0].mons[i].fatigue < 0 
                  battle.players[0].mons[i].fatigue = 0 
              i++
            i = 0
            while i < pcMonNum
              if battle.players[1].mons[i].used is false
                battle.players[1].mons[i].fatigue -= 2
                if battle.players[1].mons[i].fatigue < 0 
                  battle.players[1].mons[i].fatigue = 0 
              i++
            setAll(battle.players[0].mons, "used", false)
            setAll(battle.players[1].mons, "used", false)
        oracle = {}
        oracle.hp = 0
        oracle.max_hp = 0
        oracle.abilities = battle.summoner_abilities
        oracle.passive_ability = null
        battle.players[0].mons.push(oracle)
        window.playerMonNum = battle.players[0].mons.length
        window.pcMonNum = battle.players[1].mons.length
        battle.monAbility = (playerIndex, monIndex, abilityIndex, targetIndex) ->
          ability = @players[playerIndex].mons[monIndex].abilities[abilityIndex]
          player = @players[playerIndex]
          monster = @players[playerIndex].mons[monIndex]
          if monster.type is "summoner"
            battle.summonerCooldown += 3
          switch ability.targeta
            when "targetenemy", "attack", "random-foe"
              targets = [ player.enemies[targetIndex] ]
            when "targetally", "cleanseally", "random-ally"
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
            when "action-point"
              targets = [ battle ]
          @players[playerIndex].commandMon(monIndex, abilityIndex, targets)
          @checkRound()
        battle.evolve = (playerIndex, monIndex, evolveIndex) ->
          current_mon = @players[playerIndex].mons[monIndex]
          better_mon = @players[playerIndex].mons[monIndex].mon_evols[evolveIndex]
          added_hp = better_mon.max_hp
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
            setFatigue()
            hpChangeBattle()
  ################################################################################################################  Player logic
        $(battle.players).each ->
          player = @
          player.type = "player"
          player.turn = true
          player.ap_overload = 0
          player.gainAp = ->
            if player.ap >= battle.apGainCost
              player.ap -= battle.apGainCost
              battle.maxAP += 10
            else
              alert("You don't have enough AP!")
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
            monster.unidex = monster.team.toString()+monster.index.toString()
            window["change" + monster.unidex] = 0
            fixEvolMon(monster, player)
  #################################################################################################################  Battle general interaction
        window.documentURLObject = window.battle.monAbility.toString() + window.battle.players[0].commandMon.toString() + 
                                                                        window.battle.players[1].commandMon.toString()
        window.feed = ->
          targets.shift()
        window.currentBut = undefined
        setSummonerAbility()
        zetBut()
        availableAbilities()
        toggleEnemyClick()
        setSummonerAbility()
        $(".mute-toggle").on "click", ->
          if $(this).children("img").attr("src") is "https://s3-us-west-2.amazonaws.com/monbattle/images/mute-icon.png"
            $(".forest").append("
              <div id='button-click'></div>
            ")
            $(".battle-music").prop("muted", false)
            $(this).children("img").
              attr("src", "https://s3-us-west-2.amazonaws.com/monbattle/images/volumn-icon.png")
          else 
            $("#button-click").remove()
            $(".battle-music").prop("muted", true)
            $(this).children("img").
              attr("src", "https://s3-us-west-2.amazonaws.com/monbattle/images/mute-icon.png")
        $(".concede, .retry").on "click", ->
          muted = undefined
          if $(".battle-music").prop("muted") is true
            muted = true
          else 
            muted = false
          $.ajax
            url: "/battles/" + battle.id + "/loss"
            method: "get"
            data: {"muted": muted}
          $.ajax
            url: "/battles/" + battle.id
            method: "patch"
            data: {
              "victor": battle.players[1].username,
              "loser": battle.players[0].username,
              "round_taken": parseInt(battle.round),
              "time_taken": parseInt(seconds_taken)
            }
          $(".battle, .surrender-option-button").remove()
        $(".surrender-option-button").on "click", ->
          if $(".surrender-option-box").css("opacity") is "0"
            $(".surrender-option-box").css({"opacity":"1", "z-index":"10000"})
          else  
            $(".surrender-option-box").css("opacity", "0")
            setTimeout (->
              $(".surrender-option-box").css("z-index", "-1")          
            ), 350
        $(".battle").not(".surrender-option-box").on "click", ->
          $(".surrender-option-box").css("opacity", "0")
          setTimeout (->
            $(".surrender-option-box").css("z-index", "-1")          
          ), 350
        $(document).on("mouseover", ".battle-round-countdown", ->
          $(".bonus-description").css({"opacity":"1", "z-index":"10000"})
        ).on "mouseleave", ".battle-round-countdown", ->
          $(".bonus-description").css({"opacity":"0", "z-index":"-1"})
        $(document).on("mouseover", ".enemy.mon-slot .img", ->
          if $(this).attr("disabled") isnt "disabled"
            $(this).parent().children(".num").children(".mon-name").css("opacity", 1)
          ).on "mouseleave", ".enemy.mon-slot .img", ->
            $(this).css("background", "transparent")
            $(this).parent().children(".num").children(".mon-name").css("opacity", 0)
        $(".mon-slot .mon .img, div.mon-slot").each ->
          $(this).data "position", $(this).offset()
          return
        $(".ap .ap-number").text apInfo(battle.maxAP)
        turnOnCommandA()
        $(document).on("mouseover", ".user .monBut button, .oracle-skill-icon", ->
          $(".user .mon.mon1 .abilityDesc").removeClass("summoner-ability-description")
          element = $(this)
          ability_target = $(this).data("target")
          description = $(this).parent().parent().children(".abilityDesc")
          if $(this).attr("class") is "oracle-skill-icon"
            description = $(".user .mon.mon1 .abilityDesc")
          if $(this).css("opacity") isnt "0"
            if $(this).data("target") is "evolve"
              description.children("span.damage-type").text ""
              better_mon = battle.players[0].mons[targets[1]].mon_evols[0]
              worse_mon = battle.players[0].mons[targets[1]]
              added_hp = better_mon.max_hp
              description.children(".panel-heading").text "Ascend to " + better_mon.name
              description.children(".panel-body").html(
                better_mon.abilities[0].name + ": " + better_mon.abilities[0].description + "<br />" +
                "<br />" + better_mon.abilities[1].name + ": " + better_mon.abilities[1].description
                )
              description.children(".panel-footer").children("span").children(".d").text added_hp
              description.children(".panel-footer").children("span").children(".a").text better_mon.ap_cost
              description.children(".panel-footer").children("span").children(".sword-icon").
                attr("src", "https://s3-us-west-2.amazonaws.com/monbattle/images/heal-25px.png")
              description.css({"z-index": "1100000", "opacity": "1"})
            else
              ability = undefined
              fatigue = undefined
              if element.attr("class") is "oracle-skill-icon"
                ability = battle.players[0].mons[playerMonNum-1].abilities[0]
                $(description).addClass("summoner-ability-description")
              else 
                ability = battle.players[0].mons[targets[1]].abilities[$(this).data("index")]
              description.children(".panel-heading").text ability.name
              fatigue = battle.players[ability.team].mons[ability.index].fatigue
              if ability_target is "attack"
                description.children("span.damage-type").css("color", "#0888C4")
                description.children("span.damage-type").text "Physical"
              else
                description.children("span.damage-type").css("color", "#FFEA00")
                description.children("span.damage-type").text "Special"
              description.children(".panel-body").html ability.description
              description.children(".panel-footer").children("span").children(".d")
                .text Math.round(ability.change*ability.scaling*(1-0.1*battle.players[ability.team].mons[ability.index].fatigue))
              description.children(".panel-footer").children("span").children(".a")
                .text ability.ap_cost
              if ability.modifier is "-"
                description.children(".panel-footer").children("span").children(".sword-icon").
                  attr("src", "https://s3-us-west-2.amazonaws.com/monbattle/images/attack-25px.png")
              else 
                description.children(".panel-footer").children("span").children(".sword-icon").
                  attr("src", "https://s3-us-west-2.amazonaws.com/monbattle/images/heal-25px.png")
              description.css({"z-index": "1100000", "opacity": "1"})
          return
        ).on "mouseleave", ".user .monBut button, .oracle-skill-icon", ->
          element = $(this)
          if $(this).attr("class") is "oracle-skill-icon"
            $(".user .mon.mon1 .abilityDesc").css({"z-index":"-1", "opacity": "0"})
          else
            element.parent().parent().children(".abilityDesc").css({"z-index":"-1", "opacity": "0"})
          return
        $(document).on "click.endTurn", "button.end-turn", ->
          turnOffCommandA()
          disable($(".end-turn"))
          toggleImg()
          xadBuk()
          if deathAbilitiesToActivate["pc"].length > 0 and $("#overlay").css("display") is "none"
            wait = deathAbilitiesToActivate["pc"].length * 3400 + 2600
            setTimeout (->
              deathAbilitiesActivation("pc")
            ), 200
            setTimeout (->
              deathAbilitiesToActivate["pc"] = []
              ai()
            ), wait
          else 
            ai()
        $(document).on("mouseover", ".effect", ->
          index = @id
          e = effectBin[index]
          $(".effect-info").css("z-index", "2000")
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
            description = e.description.replace(/(\d+)/g, Math.round(e.change))
            $(".effect-info" + " " + ".panel-body").text(description)
          $(".effect-info" + " " + ".panel-heading").text(
            "Expires in" + " " + (e.end - battle.round) + " " + "turn(s)")
        ).on "mouseleave", ".effect", -> 
          index = @id
          e = effectBin[index]
          $(".effect-info").css("opacity", "0")
          $(".effect-info").css("z-index", "-1")
        $(document).on("mouseover", ".oracle-skill-icon", ->
          icon = $(this)
          if battle.summonerCooldown is 0 and $(icon).data("apcost") <= battle.players[0].ap
            $(this).css("box-shadow", "0px 0px 20px yellow")
        ).on "mouseleave", ".oracle-skill-icon", ->
          $(this).css("box-shadow", "none")
#############################################################################################################  User move interaction
        $(document).on("mouseover.ap-gain", ".gain-ap", ->
          cost = $(this).data("apcost")
          console.log($(this).data("apcost"))
          $(".ap-gain-information span").text(cost)
          $(".ap-gain-information").css({"z-index":"1000", "opacity":"1"})
        ).on "mouseleave.ap-gain", ".gain-ap", ->
          $(".ap-gain-information").css({"z-index":"-1000", "opacity":"0"})
        $(document).on "click.button", ".user.mon-slot .monBut button", ->
          $(".end-turn").prop("disabled", true)
          $(".end-turn").css("opacity", "0.5")
          ability = $(this)
          if window.battle.players[0].ap >= ability.data("apcost")
            $(".abilityDesc").css({"opacity":"0", "z-index":"-1"})
            $(".user .monBut").css({"visibility":"hidden", "opacity":"0"})
            toggleImg()
            $(document).on "click.cancel",".cancel", ->
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
              $(".user .img").each ->
                $(this).prop("disabled", false)
              availableAbilities()
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
                    leftMove = targetPosition.left - currentPosition.left + 44
                    action()
                    $(".single-ability-img").finish().css(targetPosition)
                    currentMon.finish().animate(
                      left: "+=" + leftMove.toString() + "px"
                      top: "+=" + topMove.toString() + "px"
                    , 440)
                    setTimeout (->
                      singleTargetAbilityDisplayVariable()
                      $(".single-ability-img").css({"visibility":"visible","z-index":"1000"}).
                        attr("src", "https://s3-us-west-2.amazonaws.com/monbattle/images/big-spark.gif")
                      if targetMon.css("display") isnt "none"
                        if enemyHurt.isAlive() is false
                          targetMon.css("transform":"scaleX(-1)").effect("explode", {pieces: 30}, 1000).hide()
                        else
                          targetMon.finish().animate(left: "-=60px", 200)
                      showDamageTeam(0)
                      showDamageTeam(1)
                      currentMon.finish().animate backPosition, 500
                    ), 500
                    setTimeout (->
                      targetMon.finish().animate(left: "+=60px", 700)
                      $(".single-ability-img").css({"visibility":"hidden","z-index":"-1"}).attr("src","")
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
                          setTimeout (->
                            targetMon.css("transform":"scaleX(-1)").effect("explode", {pieces: 30}, 1000).hide()
                          ), 1000
                        else
                          targetMon.effect "shake", times: 10, 750
                      element = $(this)
                      setTimeout (->
                        element.toggleClass "ability-on"
                        element.attr("src", "")
                        showDamageTeam(0)
                        showDamageTeam(1)
                        singleTargetAbilityAfterActionDisplay()
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
                        showDamageTeam(0)
                        showDamageTeam(1)
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
                          if $(this).parent().children(".img.mon-battle-image").css("display") isnt "none"
                            if battle.players[1].mons[$(this).data("index")].isAlive() is false
                              $(this).css("transform":"scaleX(-1)").effect("explode", {pieces: 30}, 1500).hide()
                            else
                              $(this).effect "shake", {times: 5, distance: 40}, 750
                        element.toggleClass "ability-on aoePositionFoe"
                        element.attr("src","")
                        showDamageTeam(0)
                        showDamageTeam(1)
                        singleTargetAbilityAfterActionDisplay()
                        return
                      ), 1500
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
                        showDamageTeam(0)
                        showDamageTeam(1)
                        singleTargetAbilityAfterActionDisplay()
                        return
                      ), 1200
                      return
                when "action-point"
                  xadBuk()
                  $(".end-turn").prop("disabled", true)
                  $(".end-turn").css("opacity", "0.5")
                  $(".user .img").removeClass("controlling")
                  battle.players[0].ap -= 
                    parseInt(battle.players[0].mons[targets[1]].abilities[targets[2]].ap_cost)
                  battle.maxAP += parseInt(battle.players[0].mons[targets[1]].abilities[targets[2]].change)
                  $("#ap-tip").toggleClass("flip animated")
                  zetBut()
                  apChange()
                  setTimeout (->
                    $(".end-turn").prop("disabled", false)
                    $(".end-turn").css("opacity", "1")
                    $("#ap-tip").toggleClass("flip animated")
                    toggleImg()
                    availableAbilities()
                    flashEndButton()
                  ), 1000
                when "evolve"
                  monster_image = $(".user .mon" + targets[1] + " .img.mon-battle-image").attr("src")
                  $(".big-ass-monster").attr("src",monster_image)
                  setTimeout (->
                    $("#animation-overlay").css({"opacity":"1", "z-index":"100000000000"})
                    $(".big-ass-monster").addClass("tinDownIn magictime")
                  ), 250
                  setTimeout (->
                    $(".big-ass-monster").removeClass("tinDownIn magictime").addClass("tinUpOut magictime")
                  ), 1250
                  setTimeout (->
                    $("#animation-overlay").css({"opacity":"0", "z-index":"-10"})
                    $(".big-ass-monster").removeClass("tinUpOut tinDownIn magictime")
                  ), 2250
                  setTimeout (->
                    $(".availability-arrow").each ->
                      $(this).css("opacity","0")
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
                      setFatigue()
                      setTimeout (->
                        toggleImg()
                        availableAbilities()
                      ), 400
                      flashEndButton()
                      return
                    ), 2000
                    return
                  ), 2500
            else
              $(ability).add(".ap").effect("highlight", {color: "red"}, 100)
              $(".end-turn").prop("disabled", false)
              $(".end-turn").css("opacity", "1")
              hopscotch.startTour(insufficient_ap_tour)
              setTimeout (->
                $(".hopscotch-nav-button.next").click()
              ), 3500






