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
  monster.isAlive = ->
    if @hp <= 0
      setTimeout (->
        $("p.dam").promise().done ->
          $("." + monster.team + " " + ".mon" + monster.index + " " + ".bar").css("width", "0%")
      ), 1200
      setTimeout (->
        $("p.dam, .bar").promise().done ->
          $("." + monster.team + " " + ".mon" + monster.index + " " + ".img").css("opacity", "0")
          $("." + monster.team + " " + ".mon" + monster.index + " " + ".hp").css("opacity", "0")
          $("." + monster.team + " " + ".mon" + monster.index + " " + ".num").css("opacity", "0")
          $("." + monster.team + " " + ".mon" + monster.index + " " + ".mon-name").css("opacity", "0")
          $("." + monster.team + " " + ".mon" + monster.index + " " + ".effect-box").fadeOut(300)
      ), 1500
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
          if a.targeta is "cleanseally" or a.targeta is "aoecleanse"
            ii = 0 
            while ii < monTarget.poisoned.length
              e = monTarget.poisoned[ii]
              delete monTarget.poisoned[ii] if e.impact.indexOf("-") isnt -1
              removeEffectIcon(monTarget, e) 
              ii++
            i3 = 0
            while i3 < monTarget.weakened.length
              e = monTarget.weakened[i3]
              delete monTarget.weakened[i3] if e.restore.indexOf("+") isnt -1
              removeEffectIcon(monTarget, e)
              i3++
            if a.modifier isnt ""
              window["change" + index] = a.change
              monTarget[a.stat] = eval(monTarget[a.stat] + a.modifier + window["change" + index])
          else if a.modifier is "-" and a.targeta is "attack"
            window["change" + index] = eval(a.change - monTarget["phy_resist"])
            window["change" + index] = 0 if window["change" + index].toString().indexOf("-") isnt -1
            monTarget[a.stat] = eval(monTarget[a.stat] + a.modifier + window["change" + index])
          else if a.modifier is "-" and (a.targeta is "targetenemy" or a.targeta is "aoeenemy") 
            window["change" + index] = eval(a.change - monTarget["spe_resist"])
            window["change" + index] = 0 if window["change" + index].toString().indexOf("-") isnt -1
            monTarget[a.stat] = eval(monTarget[a.stat] + a.modifier + window["change" + index])
          else
            window["change" + index] = a.change 
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
                monTarget["max_hp"] = eval(monTarget["max_hp"] + e.restore)
                removeEffectIcon(monTarget, e)
                addEffectIcon(monTarget, e)
              monTarget[e.stat] = eval(monTarget[e.stat] + e.modifier + e.change)
              monTarget["max_hp"] = eval(monTarget["max_hp"] + e.modifier + e.change)
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
            checkMin()
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
                console.log(monTarget[e.stat] + e.modifier + e.change)
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
        # else if e.targeta.indexOf("attack") isnt -1
        #   while i < effectTargets.length
        #     monTarget = effectTargets[i]
        #     addEffectIcon(monTarget, e)
        #     setTimeout (->
        #       $(".effect").trigger("mouseleave")
        #       removeEffectIcon(monster, e)
        #       ), 1200
        #     monTarget[e.stat] = eval(monTarget[e.stat] + e.modifier + e.change)
        #     i++
        else
          while i < effectTargets.length
            monTarget = effectTargets[i]
            addEffectIcon(monTarget, e)
            setTimeout (->
              $(".effect").trigger("mouseleave")
              massRemoveEffectIcon(e)
              ), 1500
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
    battle.players[0].mons[i].max_hp = 0 if mon.hp is 0
    i++
  i = 0
  while i < pcMonNum
    mon = battle.players[1].mons[i]
    battle.players[1].mons[i].max_hp = 0 if mon.hp is 0
    i++

window.action = ->
  xadBuk()
  checkMin()
  battle.monAbility(targets[0], targets[1], targets[2], targets[3])
  fixHp()
  checkMax()
  zetBut()
  setTimeout (->
    checkOutcome()
  ), 200

window.multipleAction = ->
  xadBuk()
  checkMin()
  battle.monAbility(targets[0], targets[1], targets[2])
  fixHp()
  checkMax()
  zetBut()
  setTimeout (->
    checkOutcome()
  ), 200

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
    when 4
      window.timerRound = 0



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
          ), 600
    ), 700


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
        $(".message").addClass("animated bounceIn")
      ), 1800
    $.ajax
      url: "/battles/" + battle.id
      method: "patch"
      data: {
        "victor": battle.players[1].username,
        "loser": battle.players[0].username,
        "round_taken": parseInt(battle.round),
        "time_taken": parseInt(time_taken)
      }
  else if battle.players[1].mons.every(isTeamDead) is true
    $.ajax
      url: "/battles/" + battle.id + "/win"
      method: "get"
      success: (response) ->
        $(".message").css("z-index", "-100000000000000000")
        $(".message").html(response)
        if $(".ability-earned").text() isnt ""
          sentence = "You have gained " + $(".ability-earned").text().replace(/\s+/g, '-') + 
                     "! It can be equipped to monsters with the following class names: " + 
                     $(".ability-earned").data("class") + ", on slot " + $(".ability-earned").data("slot") +
                     ". Go to the team editing page and find it by searching for the class name." 
          newAbilities.push(sentence)
    toggleImg()
    document.getElementById('battle').style.pointerEvents = 'none'
    $(".message").css("opacity", "0")
    $.ajax
      url: "/battles/" + battle.id
      method: "patch"
      data: {
        "victor": battle.players[0].username,
        "loser": battle.players[1].username,
        "round_taken": parseInt(battle.round),
        "time_taken": parseInt(time_taken)
      }
    if battle.end_cut_scenes.length isnt 0
      $(".cutscene").attr("src", battle.end_cut_scenes[0])
      $(".cutscene").css("opacity", "1")
      setTimeout (->
        $("#overlay").fadeIn(1000)
      ), 500
      nextSceneInitial()
    else 
      $(document).off "click.cutscene"
      $(".cutscene, .next-scene").css("opacity", "0")
      $(".message").promise().done ->
        $("#overlay").fadeIn(1000)
        setTimeout (->
          $(".next-scene").remove()
          $(".message").css("z-index", "100000")
          $(".message").addClass("animated bounceIn")
        ), 1800
    $(document).on "click.cutscene", "#overlay", ->
      if $(".cutscene").attr("src") is battle.end_cut_scenes[battle.end_cut_scenes.length-1]
        $(".cutscene").hide(500)
        endCutScene()
        setTimeout (->
          $(".next-scene").remove()
          $(".message").css("z-index", "100000")
          $(".message").addClass("animated bounceIn")
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

################################################################################################### Display function-calling helpers
window.singleTargetAbilityAfterClickDisplay = (ability) ->
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

window.singleTargetAbilityAfterActionDisplay = ->
  apChange()
  hpChangeBattle()
  checkMonHealthAfterEffect()
  turnOnCommandA()
  setTimeout (->
    toggleImg()
  ), 200
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
  setTimeout (->
    $(".next-scene").css("opacity", "0.9")
    document.getElementById('overlay').style.pointerEvents = 'auto'
  ), 1500

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
          mon.max_hp = mon.max_hp - mon.shield.extra_hp
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
              checkMin()
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
window.controlAI = (monIndex) ->
  monster = battle.players[1].mons[monIndex]
  if typeof monster isnt "undefined" 
    if monster.hp > 0
      $(".battle-message").text(
        monster.name + ":" + " " + getRandom(monster.speech)).
        effect("highlight", 500)
      abilityIndex = getRandom(aiAbilities)
      if monster.taunted.target is undefined || parseInt(battle.players[0].mons[monster.taunted.target].hp) <= 0 
        window.targetIndex = getRandom(aiTargets)
      else 
        window.targetIndex = monster.taunted.target
      ability = battle.players[1].mons[monIndex].abilities[abilityIndex]
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
          window.targets = [1].concat [monIndex, abilityIndex]
          currentMon = $(".enemy .mon" + monIndex + " " + ".img")
          currentMon.effect("bounce", {distance: 50, times: 1}, 800)
          abilityAnime = $(".ability-img")
          multipleAction()
          multipleTargetAbilityDisplayVariable()
          $(".ability-img").toggleClass "aoePositionUser", ->
            element = $(this)
            element.finish().attr("src", callAbilityImg).toggleClass("flipped ability-on")
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
        when "aoeally", "aoecleanse"
          window.targets = [1].concat [monIndex, abilityIndex]
          currentMon = $(".enemy .mon" + monIndex + " " + ".img")
          currentMon.effect("bounce", {distance: 50, times: 1}, 800)
          abilityAnime = $(".ability-img")
          checkMin()
          multipleAction()
          multipleTargetAbilityDisplayVariable()
          $(".ability-img").toggleClass "aoePositionFoe", ->
            element = $(this)
            element.finish().attr("src", callAbilityImg).toggleClass("ability-on")
            $(".enemy.mon-slot .img").each ->
              if battle.players[0].mons[$(this).data("index")].hp > 0
                $(this).effect "bounce",
                  distance: 100
                  times: 1
                , 800
            setTimeout (->
              element.toggleClass "ability-on aoePositionFoe"
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
  xadBuk()
  $(".img").removeClass("controlling")
  $(".monBut").css("visibility", "hidden")
  $(".enemy .img").attr("disabled", "true")
  toggleImg()
  $(".battle-message").fadeIn(1)
  disable($(".end-turn"))
  battle.players[0].ap = 0
  battle.players[0].turn = false
  battle.players[1].ap = 1000000000
  zetBut()
  enemyTimer()
  setTimeout (->
    feedAiTargets()
    if teamPct() isnt 0
      controlAI 1
  ), timer1
  setTimeout (->
    feedAiTargets()
    if teamPct() isnt 0
      controlAI 3
  ), timer3
  setTimeout (->
    feedAiTargets()
    if teamPct() isnt 0
      controlAI 2
  ), timer2
  setTimeout (->
    feedAiTargets()
    if teamPct() isnt 0
      controlAI 0
  ), timer0
  setTimeout (->
    if teamPct() isnt 0
      xadBuk()
      battle.players[1].turn = false
      battle.checkRound()
      roundEffectHappening(0)
      roundEffectHappening(1)
      checkMonHealthAfterEffect()
      hpChangeBattle()
      apChange()
      zetBut()
      checkOutcome() if $("#overlay").css("display") isnt "none"
      enable($("button"))
      $(".ap").effect("highlight")
      $(".battle-message").fadeOut(100)
      $(".enemy .img").removeAttr("disabled")
      toggleEnemyClick()
      $(".monBut button").trigger("mouseleave")
      toggleImg()
  ), timerRound




####################################################################################################### Start of Ajax
$ ->
  window.effectBin = []
  if document.getElementById("battle") isnt null
    $.ajax 
      url: "/battles/" + $(".battle").data("index") + ".json"
      dataType: "json"
      method: "get"
      error: ->
        alert("This battle cannot be loaded!")
      success: (data) ->
        window.battle = data
        window.seconds_taken = 0
        window.battleTimer = setInterval(increaseTime, 1000)
        if battle.start_cut_scenes.length isnt 0 
          $(".cutscene").show(500)
          toggleImg()
          nextSceneInitial()
        else 
          $(document).off "click.cutscene"
          battleStartDisplay(500)
          toggleImg()
        $(document).on "click.cutscene", "#overlay", ->
          if $(".cutscene").attr("src") is battle.start_cut_scenes[battle.start_cut_scenes.length-1]
            endCutScene()
            battleStartDisplay(1000)
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
        zetBut()
        window.currentBut = undefined
        toggleEnemyClick()
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
              if ability.targeta is "attack"
                description.children("span.damage-type").text "Physical"
              else
                description.children("span.damage-type").text "Special"
              description.children(".panel-body").html ability.description
              description.children(".panel-footer").children("span").children(".d").text ability.change
              description.children(".panel-footer").children("span").children(".a").text "AP: " + ability.ap_cost
              description.css({"z-index": "6000", "opacity": "0.9"})
          return
        ).on "mouseleave", ".user .monBut button", ->
          $(this).parent().parent().children(".abilityDesc").css({"z-index":"-1", "opacity": "0"})
          return
        $(document).on("click.endTurn", "button.end-turn", ai)
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
                      currentMon.finish().animate backPosition, 440
                    ), 460
                    setTimeout (->
                      singleTargetAbilityAfterActionDisplay()
                      toggleEnemyClick()
                      ), 1000
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
                    ), 200
                    flashEndButton()
                    return
                  ), 2000
                  return
          else
            $(this).add(".ap").effect("highlight", {color: "red"}, 100)
            alert("You have insufficient ap to use this skill.")
            $(".end-turn").prop("disabled", false)






