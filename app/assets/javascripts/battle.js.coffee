# # Place all the behaviors and hooks related to the matching controller here.
# # All this logic will automatically be available in application.js.
# # You can use CoffeeScript in this file: http://coffeescript.org/

# ########################################################################################### Evolution dressing (not very dry now)
# window.fixEvolMon = (monster, player) ->
#   monster.team = battle.players.indexOf(player)
#   monster.index = player.mons.indexOf(monster)
#   monster.isAlive = ->
#     if @hp <= 0
#       return false
#     else
#       return true
#     return
#   monster.useAbility = (abilityIndex, abilityTargets) ->
#     ability = @abilities[abilityIndex]
#     ability.use(abilityTargets)
#   $(monster.abilities).each ->
#     ability = @
#     ability.use = (abilitytargets) ->
#       a = this
#       i = 0
#       while i < abilitytargets.length
#         monTarget = abilitytargets[i]
#         monTarget[a.stat] = eval(monTarget[a.stat] + a.modifier + a.change)
#         monTarget.isAlive() if typeof monTarget.isAlive isnt "undefined"
#         i++
#       if ability.effects.length isnt 0
#         i = 0
#         while i < ability.effects.length
#           effect = a.effects[i]
#           switch effect.targeta
#             when "self"
#               effect.activate [monster]
#             when "selfbuffattack"
#               effect.activate [monster.abilities[0]]
#             when "tworandomfoes"
#               effectTargets = []
#               findAliveEnemies()
#               effectTargets.push liveFoes[0]
#               effectTargets.push liveFoes[1] if typeof liveFoes[1] isnt "undefined"
#               effect.activate effectTargets
#             when "onerandomfoe"
#               effectTargets = []
#               findAliveEnemies()
#               effectTargets.push liveFoes[0]
#               effect.activate effectTargets
#             when "tworandommons"
#               findAliveEnemies()
#               findAliveFriends()
#               findAliveMons()
#               effectTargets = []
#               effectTargets.push liveMons[0]
#               effectTargets.push liveMons[1] if typeof liveMons[1] isnt "undefined"
#               effect.activate effectTargets
#             when "foebuffattack"
#               effectTargets = []
#               i = 0
#               while i < abilitytargets.length
#                 index = getRandom([0,1,2,3])
#                 effectTargets.push abilitytargets[i].abilities[index]
#                 i++
#               effect.activate effectTargets
#             when "tworandomallies"
#               effectTargets = []
#               findAliveFriends()
#               effectTargets.push liveFriends[0]
#               effectTargets.push liveFriends[1] if typeof liveFriends[1] isnt "undefined"
#               effect.activate effectTargets
#             when "randomap"
#               effectTargets = [player]
#               effect.activate effectTargets
#           i++
#       return
#     $(ability.effects).each ->
#       @activate = (effectTargets) ->
#         e = this
#         i = 0
#         if typeof e.random isnt "undefined"
#           while i < effectTargets.length
#             monTarget = effectTargets[i]
#             monTarget[e.stat] = eval(monTarget[e.stat] + e.modifier + randomNumRange(e.max, e.min).toString())
#             checkMin()
#             checkMax()
#             monTarget.isAlive() if typeof monTarget.isAlive isnt "undefined"
#             i++
#           return
#         else
#           while i < effectTargets.length
#             monTarget = effectTargets[i]
#             monTarget[e.stat] = eval(monTarget[e.stat] + e.modifier + e.change)
#             checkMin()
#             checkMax()
#             monTarget.isAlive() if typeof monTarget.isAlive isnt "undefined"
#             i++
#           return


# ################################################################################################# Battle logic helpers
# window.isTeamDead = (monster, index, array) ->
#   monster.isAlive() is false
# window.isTurnOver = (object, index, array) ->
#   object.turn is false
# window.noApLeft = (object, index, array) ->
#   $(object).data("apcost") > battle.players[0].ap
# window.nothingToDo = (object, index, array) ->
#   $(object).css("opacity") is "0"

# window.setAll = (array, attr, value) ->
#   n = array.length
#   i = 0
#   while i < n
#     array[i][attr] = value
#     i++
#   return

# window.checkMax = ->
#   n = battle.players[0].mons.length
#   i = 0
#   while i < n
#     mon = battle.players[0].mons[i]
#     battle.players[0].mons[i].hp = mon.max_hp if mon.hp > mon.max_hp
#     i++
#   return

# window.checkMin = ->
#   n = battle.players[0].mons.length
#   i = 0
#   while i < n
#     mon = battle.players[0].mons[i]
#     battle.players[0].mons[i].max_hp = 0 if mon.hp is 0
#     i++
#   return

# window.action = ->
#   battle.monAbility(targets[0], targets[1], targets[2], targets[3])
# window.multipleAction = ->
#   battle.monAbility(targets[0], targets[1], targets[2])
# window.userMon = (index) ->
#   $(".user .mon" + index.toString() + " " + ".img")

# window.numOfDeadFoe = ->
#   num = 0
#   n = 3
#   i = 0
#   while i <= n
#     if battle.players[1].mons[i].isAlive() is false
#       num += 1
#     i++
#   return num
# window.checkEnemyDeath = (index) ->
#   return !battle.players[1].mons[index].isAlive()

# window.shuffle = (array) ->
#   i = array.length - 1

#   while i > 0
#     j = Math.floor(Math.random() * (i + 1))
#     temp = array[i]
#     array[i] = array[j]
#     array[j] = temp
#     i--
#   array

# window.findAliveEnemies =  ->
#   window.liveFoes = []
#   n = 3
#   i = 0
#   while i <= n
#     if battle.players[0].enemies[i].isAlive() is true
#       liveFoes.push battle.players[0].enemies[i]
#     i++
#   shuffle(liveFoes)

# window.findAliveFriends = ->
#   window.liveFriends = []
#   n = 3
#   i = 0
#   while i <= n
#     if battle.players[0].mons[i].isAlive() is true
#       liveFriends.push battle.players[0].mons[i]
#     i++
#   shuffle(liveFriends)

# window.findAliveMons = ->
#   window.liveMons = liveFriends.concat liveFoes
#   shuffle(window.liveMons)

# window.randomNumRange = (max, min)->
#   Math.floor(Math.random() * (max - min) + min)


# #########################################################################################################  AI timer
# window.enemyTimer = ->
#   window.timer1 = 0
# ######################################################################
#   if checkEnemyDeath(1) is true
#     window.timer3 = 0
#   else
#     window.timer3 = 2200
# ######################################################################
#   if checkEnemyDeath(1) is true && checkEnemyDeath(3) is true
#     window.timer2 = 0
#   else if checkEnemyDeath(1) is true || checkEnemyDeath(3) is true
#     window.timer2 = 2200
#   else
#     window.timer2 = 4400
# ######################################################################
#   if checkEnemyDeath(1) && checkEnemyDeath(3) && checkEnemyDeath(2)
#     window.timer0 = 0
#   else if ( ( checkEnemyDeath(1) && checkEnemyDeath(2) ) || ( checkEnemyDeath(1) && checkEnemyDeath(3) ) ) ||
#           ( checkEnemyDeath(2) && checkEnemyDeath(3) )
#     window.timer0 = 2200
#   else if ( checkEnemyDeath(1) || checkEnemyDeath(2) ) || checkEnemyDeath(3)
#     window.timer0 = 4400
#   else
#     window.timer0 = 6600
# ######################################################################
#   switch numOfDeadFoe()
#     when 0
#       window.timerRound = 8800
#     when 1
#       window.timerRound = 6600
#     when 2
#       window.timerRound = 4400
#     when 3
#       window.timerRound = 2200



# ######################################################################################################## Battle display helpers
# window.callAbilityImg = ->
#   battle.players[targets[0]].mons[targets[1]].abilities[targets[2]].img

# window.barChange = (current, max) ->
#   "width": (current/max*100).toString() + "%"

# window.apNum = ".ap .ap-number"

# window.apBar = ".ap-meter .bar"

# window.apInfo = (maxAP) ->
#   "AP:" + "   " + maxAP + " / " + maxAP

# window.apAfterUse = (current, max) ->
#   "AP:" + "   " + current + " / " + max

# window.apChange = ->
#   $(apNum).text apAfterUse(battle.players[0].ap , battle.maxAP)
#   $(apBar).animate barChange(battle.players[0].ap, battle.maxAP), 200

# window.hpChange = (side, index) ->
#   "." + side + ".info" + " " + ".mon" + index.toString() + " " + ".current-hp"

# window.hpBarChange = (side, index) ->
#   "." + side + " " + ".mon" + index.toString() + " " + ".hp .bar"

# window.hpChangeBattle = ->
#   i = undefined
#   n = undefined
#   n = 3
#   i = 0
#   while i <= n
#     battle.players[0].mons[i].hp = (if (battle.players[0].mons[i].hp < 0) then 0 else battle.players[0].mons[i].hp)
#     battle.players[1].mons[i].hp = (if (battle.players[1].mons[i].hp < 0) then 0 else battle.players[1].mons[i].hp)
#     $(hpBarChange("0", i)).animate barChange(battle.players[0].mons[i].hp, battle.players[0].mons[i].max_hp), 200 if battle.
#                     players[0].mons[i].hp.toString() != $(".user.info" + " " + ".mon" + i.toString() + " " + ".current-hp").text()

#     $(hpBarChange("1", i)).animate barChange(battle.players[1].mons[i].hp, battle.players[1].mons[i].max_hp), 200 if battle.
#                     players[1].mons[i].hp.toString() != $(".user.info" + " " + ".mon" + i.toString() + " " + ".current-hp").text()
#     $(hpChange("0", i)).text battle.players[0].mons[i].hp
#     $(hpChange("1", i)).text battle.players[1].mons[i].hp
#     i++

# window.damageBoxAnime= (team, target, damage, color) ->
#   $("." + team + " " + ".mon" + target + " " + "p.dam").text(damage).animate({"color":color, "font-weight":"bold"}, 1).
#   fadeIn(1).animate({"top":"-=50px", "z-index":"+=10000"}, 200).effect("bounce", {times: 10}).fadeOut().
#   animate
#     "top":"+=50px"
#     "z-index":"-=10000"
#     , 5, ->
#       $(".img, .ability-img, .single-ability-img").promise().done ->
#         $(".img, .ability-img, .single-ability-img, p.dam").promise().done ->
#           setTimeout (->
#             $("p.dam").promise().done ->
#               outcome()
#           ), 100

# window.showDamageSingle = ->
#   damageBoxAnime(enemyHurt.team, enemyHurt.index, ability.modifier + ability.change, "rgba(255, 0, 0)")

# window.showHealSingle = ->
#   damageBoxAnime(allyHealed.team, allyHealed.index, ability.modifier + ability.change, "rgba(50,205,50)")

# window.showDamageTeam = (index) ->
#   i = undefined
#   n = undefined
#   n = 3
#   i = 0
#   while i <= n
#     if parseInt($("." + index.toString() + " " + ".mon" + i.toString() + " " + ".current-hp").text()) > 0
#       damageBoxAnime(index, i.toString(), ability.modifier + ability.change, "rgba(255, 0, 0)")
#     i++

# window.showHealTeam = (index) ->
#   i = undefined
#   n = undefined
#   n = 3
#   i = 0
#   while i <= n
#     if battle.players[index].mons[i].hp > 0
#       damageBoxAnime(index, i.toString(), ability.modifier + ability.change, "rgba(50, 205, 50)")
#     i++

# window.outcome = ->
#   if battle.players[0].mons.every(isTeamDead) is true
#     $(".message").text("You lost, but here's " + battle.reward*0.1 + " MP because we pity you. Try harder next time!").
#       append("<br/><br/><a href='/battles/new' class='btn btn-danger'>Avenge your time</a>")
#     $("#overlay").fadeIn(1000)
#     $(".battle-message").fadeOut(1000)
#     $("body").on "click", ->
#       $("#overlay").fadeOut(500)
#       disable($(".end-turn"))
#     $.ajax
#       url: "http://localhost:3000/battles/" + battle.id
#       method: "patch"
#       data: {
#         "victor": battle.players[1].username,
#         "loser": battle.players[0].username
#       }
#   else if battle.players[1].mons.every(isTeamDead) is true
#     $(".message").text("You won" + " " + battle.reward + " " + "MP!" + "Go kill more monsters!").
#       append("<br/><br/><a href='/battles/new' class='btn btn-success'>Continue your journey</a>")
#     $("#overlay").fadeIn(1000)
#     $(".battle-message").fadeOut(1000)
#     $("body").on "click", ->
#       $("#overlay").fadeOut(500)
#       disable($(".end-turn"))
#     $.ajax
#       url: "http://localhost:3000/battles/" + battle.id
#       method: "patch"
#       data: {
#         "victor": battle.players[0].username,
#         "loser": battle.players[1].username
#       }
#   return

# window.checkApAvailbility = ->
#   $(".monBut button").each ->
#     disable($(this)) if $(this).data("apcost") > battle.players[0].ap


# window.checkMonHealthAfterEffect = ->
#   i = 0
#   n = 3
#   while i <= n
#     $(".0 .mon" + i.toString() + " " + ".img").fadeOut() if battle.players[0].mons[i].hp <= 0
#     $(".1 .mon" + i.toString() + " " + ".img").fadeOut() if battle.players[1].mons[i].hp <= 0
#     i++



# ################################################################################################### Display function-calling helpers
# window.singleTargetAbilityAfterClickDisplay = ->
#   turnOff("click.boom", ".enemy")
#   turnOff("click.help", ".user")
#   $(document).off "click.cancel", ".cancel"
#   $(".user .img").removeClass("controlling")
#   $(".battle-guide").hide()

# window.singleTargetAbilityAfterActionDisplay = ->
#   apChange()
#   hpChangeBattle()
#   checkMonHealthAfterEffect()
#   toggleImg()
#   flashEndButton()



# ################################################################################################### Battle display variable helpers
# window.singleTargetAbilityDisplayVariable = ->
#   window.enemyHurt = battle.players[targets[0]].enemies[targets[3]]
#   window.monsterUsed = battle.players[targets[0]].mons[targets[1]]
#   window.ability = battle.players[targets[0]].mons[targets[1]].abilities[targets[2]]

# window.singleHealTargetAbilityDisplayVariable = ->
#   window.allyHealed = battle.players[targets[0]].mons[targets[3]]
#   window.monsterUsed = battle.players[targets[0]].mons[targets[1]]
#   window.ability = battle.players[targets[0]].mons[targets[1]].abilities[targets[2]]

# window.multipleTargetAbilityDisplayVariable = ->
#   window.ability = battle.players[targets[0]].mons[targets[1]].abilities[targets[2]]
#   window.monsterUsed = battle.players[targets[0]].mons[targets[1]]



# ################################################################################################### Battle interaction helpers
# window.mouseOverMon = ->
#   console.log($(this))
#   $(this).addClass("controlling")
#   $(this).prev().css "visibility", "visible"
#   mon = $(this).closest(".mon").data("index")
#   team = $(this).closest(".mon-slot").data("team")
#   window.currentMon = $(this)
#   window.targets = [
#     team
#     mon
#   ]
#   return

# window.mouseLeaveMon = ->
#   $(".user .monBut").css "visibility","hidden"
#   $(".user .img").removeClass("controlling")

# window.control = ->
#   button = $(this).prev().css("visibility")
#   if button is "visible"
#     $(".user .monBut").css "visibility","hidden"
#     $(".user .img").removeClass("controlling")
#   else
#     $(".user .img").removeClass("controlling")
#     $(".user .monBut").css "visibility","hidden"
#     $(this).addClass("controlling")
#     $(this).prev().css "visibility", "visible"
#     mon = $(this).closest(".mon").data("index")
#     team = $(this).closest(".mon-slot").data("team")
#     window.currentMon = $(this)
#     window.targets = [
#       team
#       mon
#     ]
#   return

# window.turnOnCommandA = ->
#   $(document).on "mouseleave.command", ".user.mon-slot .mon", mouseLeaveMon
#   $(document).on "mouseover.command", ".user.mon-slot .img", mouseOverMon

# window.turnOffCommandA = ->
#   $(document).off "mouseleave.command", ".user.mon-slot .mon", mouseLeaveMon
#   $(document).off "mouseover.command", ".user.mon-slot .img", mouseOverMon

# window.turnOnCommand = (funk) ->
#   $(document).on "click.command", ".user.mon-slot .img", funk

# window.turnOffCommand = (funk) ->
#   $(document).off "click.command", ".user.mon-slot .img", funk

# window.turnOff = (name, team) ->
#   $(document).off name, team + ".mon-slot .img"

# window.disable = (button) ->
#   button.attr("disabled", "true")
#   button.animate({"background-color":"rgba(192, 192, 192, 0)", "border-color":"black"
#                 , "opacity":"0"})

# window.enable = (button) ->
#   button.removeAttr("disabled")
#   button.animate({"background-color":"rgba(10, 170, 230, 0.80)", "border-color":"black"
#                 , "opacity":"1"})

# window.toggleImg = ->
#   $(".user .img").each ->
#     if $(this).attr("disabled") is "disabled"
#       $(this).removeAttr("disabled")
#     else
#       $(this).attr("disabled", "true")

# window.flashEndButton = ->
#   buttonArray = []
#   $(".end-turn").prop("disabled", false)
#   $(".monBut button").each ->
#     if $(this).parent().parent().children(".img").css("display") isnt "none" && $(this).attr("disabled") isnt "disabled"
#       buttonArray.push $(this)
#   if buttonArray.every(noApLeft) || buttonArray.every(nothingToDo)
#     setTimeout (->
#       $(".end-turn").trigger("click")
#       return
#     ), 800
#     return


# window.toggleEnemyClick = ->
#   $(".enemy .img").each ->
#     if $(this).attr("disabled") is "disabled"
#       $(this).prop("disabled", false)
#     else
#       $(this).prop("disabled", true)



# ################################################################################################################ AI logic helpers
# window.findTargetsBelowPct = (pct) ->
#   i = undefined
#   n = undefined
#   n = 3
#   i = 0
#   window.aiTargets = []
#   while i <= n
#     aiTargets.push battle.players[0].mons[i].index if battle.players[0].mons[i].hp/battle.players[0].mons[i].max_hp <= pct &&
#                                                       battle.players[0].mons[i].hp > 0
#     i++
#   return
# window.findTargetsAbovePct = (pct) ->
#   i = undefined
#   n = undefined
#   n = 3
#   i = 0
#   window.aiTargets = []
#   while i <= n
#     aiTargets.push battle.players[0].mons[i].index if battle.players[0].mons[i].hp/battle.players[0].mons[i].max_hp >= pct &&
#                                                       battle.players[0].mons[i].hp > 0
#     i++
#   return
# window.findTargets = (hp) ->
#   i = undefined
#   n = undefined
#   n = 3
#   i = 0
#   window.aiTargets = []
#   while i <= n
#     aiTargets.push battle.players[0].mons[i].index if battle.players[0].mons[i].hp <= hp &&
#                                                       battle.players[0].mons[i].hp > 0
#     i++
#   return
# window.totalUserHp = ->
#   i = undefined
#   n = undefined
#   totalCurrentHp = 0
#   n = 3
#   i = 0
#   while i <= n
#     totalCurrentHp += battle.players[0].mons[i].hp
#     i++
#   return totalCurrentHp
# window.teamPct = ->
#   i = undefined
#   n = undefined
#   totalMaxHp = 0
#   n = 3
#   i = 0
#   while i <= n
#     totalMaxHp += battle.players[0].mons[i].max_hp
#     i++
#   return totalUserHp()/totalMaxHp
# window.getRandom = (array) ->
#   return array[Math.floor(Math.random()*array.length)]
# window.selectTarget = ->
#   return getRandom(aiTargets)



# ############################################################################################################ AI logics
# window.feedAiTargets = ->
#   if battle.round > 5 && teamPct() > 0.6
#     window.aiAbilities = [2,3]
#     findTargetsAbovePct(0.5)
#     findTargetsBelowPct(0.9) if aiTargets.length is 0
#   else if teamPct() > 0.8
#     window.aiAbilities = [0,1]
#     findTargetsBelowPct(1)
#   else if teamPct() <= 0.8 && teamPct() > 0.6
#     window.aiAbilities = [1,2]
#     findTargetsBelowPct(0.5)
#     findTargetsBelowPct(0.9) if aiTargets.length is 0
#   else if teamPct() <= 0.6 && teamPct() > 0.4
#     window.aiAbilities = [1,3]
#     findTargetsAbovePct(0.6)
#     findTargetsAbovePct(0.3) if aiTargets.length is 0
#   else if teamPct() <= 0.4 && teamPct() > 0.2
#     window.aiAbilities = [2,3]
#     findTargets(1800)
#     findTargets(3500) if aiTargets.length is 0
#   else if teamPct() <= 0.2
#     window.aiAbilities = [0,3]
#     findTargets(1000)
#     findTargets(3500) if aiTargets.length is 0




# ############################################################################################################ AI action helpers
# window.controlAI = (monIndex) ->
#   monster = battle.players[1].mons[monIndex]
#   if monster.hp > 0
#     $(".battle-message").text(
#       monster.name + ":" + " " + getRandom(monster.speech)).
#       effect("highlight", 500)
#     battle.players[1].ap = 1000000000
#     abilityIndex = getRandom(aiAbilities)
#     targetIndex = getRandom(aiTargets)
#     ability = battle.players[1].mons[monIndex].abilities[abilityIndex]
#     switch ability.targeta
#       when "attack"
#         window.targets = [1].concat [monIndex, abilityIndex, targetIndex]
#         action()
#         currentMon = $(".enemy .mon" + monIndex.toString() + " " + ".img")
#         currentPosition = currentMon.data("position")
#         targetMon = userMon(targetIndex)
#         targetPosition = targetMon.data("position")
#         backPosition = currentMon.position()
#         topMove = targetPosition.top - currentPosition.top
#         leftMove = targetPosition.left - currentPosition.left - 60
#         currentMon.animate(
#           "left": "+=" + leftMove.toString() + "px"
#           "top": "+=" + topMove.toString() + "px"
#         , 350, ->
#           checkMax
#           singleTargetAbilityDisplayVariable()
#           if targetMon.css("display") isnt "none"
#             if enemyHurt.isAlive() is false
#               targetMon.effect("explode", {pieces: 30}, 1000).hide()
#             else
#               targetMon.effect "shake", 750
#         ).animate backPosition, 350, ->
#           showDamageSingle()
#           hpChangeBattle()
#           checkMonHealthAfterEffect()
#       when "targetenemy"
#         window.targets = [1].concat [monIndex, abilityIndex, targetIndex]
#         currentMon = $(".enemy .mon" + monIndex.toString() + " " + ".img")
#         currentMon.effect("bounce", {distance: 50, times: 1}, 800)
#         targetMon = userMon(targetIndex)
#         targetPosition = targetMon.data("position")
#         abilityAnime = $(".single-ability-img")
#         singleTargetAbilityDisplayVariable()
#         abilityAnime.css(targetPosition)
#         abilityAnime.attr("src", callAbilityImg).toggleClass "flipped ability-on", ->
#           action()
#           if targetMon.css("display") isnt "none"
#             if enemyHurt.isAlive() is false
#               targetMon.effect("explode", {pieces: 30}, 1000).hide()
#             else
#               targetMon.effect "shake", times: 10, 750
#           element = $(this)
#           checkMax()
#           setTimeout (->
#             showDamageSingle()
#             hpChangeBattle()
#             checkMonHealthAfterEffect()
#             element.toggleClass "flipped ability-on"
#             element.attr("src", "")
#             return
#           ), 1200
#           return
#       when "aoeenemy"
#         window.targets = [1].concat [monIndex, abilityIndex]
#         currentMon = $(".enemy .mon" + monIndex.toString() + " " + ".img")
#         currentMon.effect("bounce", {distance: 50, times: 1}, 800)
#         abilityAnime = $(".ability-img")
#         multipleAction()
#         checkMax()
#         multipleTargetAbilityDisplayVariable()
#         $(".ability-img").toggleClass "aoePositionUser", ->
#           element = $(this)
#           element.attr("src", callAbilityImg).toggleClass("flipped ability-on")
#           $(".user.mon-slot .img").each ->
#             if $(this).css("display") isnt "none"
#               if battle.players[0].mons[$(this).data("index")].isAlive() is false
#                 $(this).effect("explode", {pieces: 30}, 1200).hide()
#               else
#                 $(this).effect "shake", {times: 5, distance: 40}, 750
#           setTimeout (->
#             element.toggleClass "flipped ability-on aoePositionUser"
#             element.attr("src", "")
#             showDamageTeam(0)
#             hpChangeBattle()
#             checkMonHealthAfterEffect()
#             return
#           ), 1200
#           return

# window.AiObj = init: (monIndex) ->
#   promise = controlAI(monIndex)
#   promise



# ############################################################################################################### AI actions
# window.ai = ->
#   $(".img").removeClass("controlling")
#   $(".monBut").css("visibility", "hidden")
#   $(".enemy .img").attr("disabled", "true")
#   toggleImg()
#   $(".battle-message").fadeIn(1)
#   disable($(".end-turn"))
#   battle.players[0].ap = 0
#   battle.players[0].turn = false
#   enemyTimer()
#   setTimeout (->
#     feedAiTargets()
#     if teamPct() isnt 0
#       controlAI 1
#       return
#   ), timer1
#   setTimeout (->
#     feedAiTargets()
#     if teamPct() isnt 0
#       controlAI 3
#       return
#   ), timer3
#   setTimeout (->
#     feedAiTargets()
#     if teamPct() isnt 0
#       controlAI 2
#       return
#   ), timer2
#   setTimeout (->
#     feedAiTargets()
#     if teamPct() isnt 0
#       controlAI 0
#       return
#   ), timer0
#   setTimeout (->
#     if teamPct() isnt 0
#       battle.players[1].turn = false
#       battle.checkRound()
#       apChange()
#       enable($("button"))
#       $(".ap").effect("pulsate", {times: 5}, 1500)
#       $(".battle-message").fadeOut(100)
#       toggleImg()
#       $(".enemy .img").removeAttr("disabled")
#       toggleEnemyClick()
#       return
#   ), timerRound



# ############################################################################################## Start of Ajax
# $ ->
#   $.ajax if $(".battle").length > 0
#     url: "http://localhost:3000/battles/" + $(".battle").data("index") + ".json"
#     dataType: "json"
#     method: "get"
#     error: ->
#       alert("This battle cannot be loaded!")
#     success: (data) ->
#       setTimeout (->
#         $("#overlay").fadeOut 500, ->
#           $(".battle-message").show(500).effect("highlight", 500).fadeOut(300)
#           $(".message").css("visibility", "visible")
#           $(".cutscene").css("visibility", "hidden")
#           return
#       ), 4000
#       setTimeout (->
#         $("#battle-tutorial").joyride({'tipLocation': 'top'})
#         $("#battle-tutorial").joyride({})
#         $(".user .img").each ->
#           $(this).effect("bounce", {distance: 80, times: 5}, 1500)
#       ), 6000
# ############################################################################################### Battle logic
#       window.battle = data
#       $(".battle").css({"background": "url(#{battle.background})", "background-repeat":"none", "background-size":"cover"})
#       battle.round = 1
#       battle.maxAP = 40
#       battle.calculateAP = ->
#         if battle.round < 5
#           battle.maxAP = 30 + 10 * battle.round
#         else
#           battle.maxAP = 80
#       battle.players[0].enemies = battle.players[1].mons
#       battle.players[1].enemies = battle.players[0].mons
#       setAll(battle.players, "ap", battle.maxAP)
#       battle.checkRound = ->
#         if battle.players.every(isTurnOver)
#           battle.round += 1
#           battle.calculateAP()
#           setAll(battle.players, "turn", true)
#           setAll(battle.players, "ap", battle.maxAP)
#           console.log("This round is over.")
#         else
#           console.log("This ain't over.")
#         return
#       battle.monAbility = (playerIndex, monIndex, abilityIndex, targetIndex) ->
#         ability = @players[playerIndex].mons[monIndex].abilities[abilityIndex]
#         player = @players[playerIndex]
#         monster = @players[playerIndex].mons[monIndex]
#         switch ability.targeta
#           when "targetenemy", "attack"
#             targets = [ player.enemies[targetIndex] ]
#           when "targetally"
#             targets = [ player.mons[targetIndex] ]
#           when "aoeenemy"
#             targets = player.enemies
#           when "aoeally"
#             targets = player.mons
#           when "ability"
#             targets = [player.mons[targetIndex].abilities[0]]
#         @players[playerIndex].commandMon(monIndex, abilityIndex, targets)
#         @checkRound()
#       battle.evolve = (playerIndex, monIndex, evolveIndex) ->
#         current_mon = @players[playerIndex].mons[monIndex]
#         better_mon = @players[playerIndex].mons[monIndex].mon_evols[evolveIndex]
#         added_hp = better_mon.max_hp - current_mon.max_hp
#         evolved_hp = current_mon.hp + added_hp
#         if battle.players[playerIndex].ap >= better_mon.ap_cost
#           battle.players[playerIndex].ap -= better_mon.ap_cost
#           battle.players[playerIndex].mons[monIndex] = better_mon
#           fixEvolMon(battle.players[playerIndex].mons[monIndex], battle.players[playerIndex])
#           evolved_mon = battle.players[playerIndex].mons[monIndex]
#           battle.players[playerIndex].mons[monIndex].hp = evolved_hp
#           damageBoxAnime(0, targets[1], "+" + added_hp.toString(), "rgba(50,205,50)")
#           monDiv = ".0 .mon" + targets[1].toString()
#           $(monDiv + " " + ".max-hp").text("/" + " " + better_mon.max_hp)
#           $(monDiv + " " + ".attack").data("apcost", evolved_mon.abilities[0].ap_cost)
#           $(monDiv + " " + ".ability").data("target", evolved_mon.abilities[1].targeta)
#           $(monDiv + " " + ".ability").data("apcost", evolved_mon.abilities[1].ap_cost)
#           hpChangeBattle()
# #################################################################################################  Player logic
#       $(battle.players).each ->
#         player = @
#         player.turn = true
#         player.commandMon = (monIndex, abilityIndex, targets) ->
#           p = @
#           mon = p.mons[monIndex]
#           abilityCost = mon.abilities[abilityIndex].ap_cost
#           if p.ap >= abilityCost
#             p.ap -= abilityCost
#             mon.useAbility abilityIndex, targets
#           else
#             alert("You do not have enough ap to use this ability")
#           return
# #################################################################################################  Monster logic
#         $(player.mons).each ->
#           monster = @
#           monster.team = battle.players.indexOf(player)
#           monster.index = player.mons.indexOf(monster)
#           monster.isAlive = ->
#             if @hp <= 0
#               return false
#             else
#               return true
#             return
#           monster.useAbility = (abilityIndex, abilityTargets) ->
#             ability = @abilities[abilityIndex]
#             ability.use(abilityTargets)
# ##################################################################################################  Ability logic
#           $(monster.abilities).each ->
#             ability = @
#             ability.use = (abilitytargets) ->
#               a = this
#               i = 0
#               while i < abilitytargets.length
#                 monTarget = abilitytargets[i]
#                 monTarget[a.stat] = eval(monTarget[a.stat] + a.modifier + a.change)
#                 monTarget.isAlive() if typeof monTarget.isAlive isnt "undefined"
#                 i++
#               if ability.effects.length isnt 0
#                 i = 0
#                 while i < ability.effects.length
#                   effect = a.effects[i]
#                   switch effect.targeta
#                     when "self"
#                       effect.activate [monster]
#                     when "selfbuffattack"
#                       effect.activate [monster.abilities[0]]
#                     when "tworandomfoes"
#                       effectTargets = []
#                       findAliveEnemies()
#                       effectTargets.push liveFoes[0]
#                       effectTargets.push liveFoes[1] if typeof liveFoes[1] isnt "undefined"
#                       effect.activate effectTargets
#                     when "onerandomfoe"
#                       effectTargets = []
#                       findAliveEnemies()
#                       effectTargets.push liveFoes[0]
#                       effect.activate effectTargets
#                     when "tworandommons"
#                       findAliveEnemies()
#                       findAliveFriends()
#                       findAliveMons()
#                       effectTargets = []
#                       effectTargets.push liveMons[0]
#                       effectTargets.push liveMons[1] if typeof liveMons[1] isnt "undefined"
#                       effect.activate effectTargets
#                     when "foebuffattack"
#                       effectTargets = []
#                       i = 0
#                       while i < abilitytargets.length
#                         index = getRandom([0,1,2,3])
#                         effectTargets.push abilitytargets[i].abilities[index]
#                         i++
#                       effect.activate effectTargets
#                     when "tworandomallies"
#                       effectTargets = []
#                       findAliveFriends()
#                       effectTargets.push liveFriends[0]
#                       effectTargets.push liveFriends[1] if typeof liveFriends[1] isnt "undefined"
#                       effect.activate effectTargets
#                     when "randomap"
#                       effectTargets = [player]
#                       effect.activate effectTargets
#                   i++
#               return
# ##################################################################################################### Effect logic
#             $(ability.effects).each ->
#               @activate = (effectTargets) ->
#                 e = this
#                 i = 0
#                 if typeof e.random isnt "undefined"
#                   while i < effectTargets.length
#                     monTarget = effectTargets[i]
#                     monTarget[e.stat] = eval(monTarget[e.stat] + e.modifier + randomNumRange(e.max, e.min).toString())
#                     checkMin()
#                     checkMax()
#                     monTarget.isAlive() if typeof monTarget.isAlive isnt "undefined"
#                     i++
#                   return
#                 else
#                   while i < effectTargets.length
#                     monTarget = effectTargets[i]
#                     monTarget[e.stat] = eval(monTarget[e.stat] + e.modifier + e.change)
#                     checkMin()
#                     checkMax()
#                     monTarget.isAlive() if typeof monTarget.isAlive isnt "undefined"
#                     i++
#                   return
# ###############################################################################################  Battle interaction
#       window.feed = ->
#         targets.shift()
#       window.currentBut = undefined
#       toggleEnemyClick()
#       $(".mon-slot .mon .img, div.mon-slot").each ->
#         $(this).data "position", $(this).offset()
#         return
#       $(".ap .ap-number").text apInfo(battle.maxAP)
#       turnOnCommandA()
#       $(document).on("mouseover", ".user .monBut button", ->
#         description = $(this).parent().parent().children(".abilityDesc")
#         $(this).css("background", "rgba(8,136,196,1)")
#         if $(this).data("target") is "evolve"
#           better_mon = battle.players[0].mons[targets[1]].mon_evols[0]
#           worse_mon = battle.players[0].mons[targets[1]]
#           added_hp = better_mon.max_hp - worse_mon.max_hp
#           description.children(".panel-heading").text better_mon.name
#           description.children(".panel-body").html(
#             better_mon.abilities[0].name + ": " + better_mon.abilities[0].description + "<br />" +
#             "<br />" + better_mon.abilities[1].name + ": " + better_mon.abilities[1].description
#             )
#           description.children(".panel-footer").children("span").children(".d").text "HP: +" + added_hp
#           description.children(".panel-footer").children("span").children(".a").text "AP: " + better_mon.ap_cost
#           description.css "visibility", "visible"
#         else
#           ability = battle.players[0].mons[targets[1]].abilities[$(this).data("index")]
#           description.children(".panel-heading").text ability.name
#           description.children(".panel-body").html ability.description
#           description.children(".panel-footer").children("span").children(".d").text ability.change
#           description.children(".panel-footer").children("span").children(".a").text "AP: " + ability.ap_cost
#           description.css "visibility", "visible"
#         return
#       ).on "mouseleave", ".user .monBut button", ->
#         $(this).parent().parent().children(".abilityDesc").css "visibility", "hidden"
#         $(this).css("background-image", "-webkit-linear-gradient(top, #606060 0%, #131313 100%)")
#         return
#       $(document).on("click.endTurn", "button.end-turn", ai)
# #####################################################################################################  User move interaction
#       $(document).on "click.button", ".user.mon-slot .monBut button", ->
#         $(".end-turn").prop("disabled", true)
#         ability = $(this)
#         if window.battle.players[0].ap >= ability.data("apcost")
#           $(".abilityDesc").css "visibility", "hidden"
#           $(".user .monBut").css("visibility","hidden")
#           toggleImg()
#           $(document).on "click.cancel",".cancel", ->
#             $(".user .img").removeClass("controlling")
#             $(".battle-guide").hide()
#             $(".end-turn").prop("disabled", false)
#             $(document).off "click.boom", ".enemy.mon-slot .img"
#             $(document).off "click.help", ".user.mon-slot .img"
#             $(document).off "click.cancel", ".cancel"
#             $(".enemy .img").each ->
#               $(this).prop("disabled", true)
#             toggleImg()
#             if ability.data("target") is "targetally" || ability.data("target") is "ability"
#               toggleImg()
#               turnOnCommandA()
#             targets = []
#             return
#           window.targets = targets.concat(ability.data("index"))  if targets.length isnt 3
#           if targets.length isnt 0
#             switch ability.data("target")
# #################################################################################################  Player ability interaction
#               when "attack"
#                 toggleEnemyClick()
#                 $(".battle-guide.guide").text("Select an enemy target")
#                 $(".battle-guide").show()
#                 $(document).on "click.boom", ".enemy.mon-slot .img", ->
#                   disable(ability)
#                   singleTargetAbilityAfterClickDisplay()
#                   targetMon = $(this)
#                   monDiv = targetMon.parent()
#                   window.targets = targets.concat(monDiv.data("index"))
#                   targetPosition = $(this).data("position")
#                   currentPosition = currentMon.data("position")
#                   backPosition = currentMon.position()
#                   topMove = targetPosition.top - currentPosition.top
#                   leftMove = targetPosition.left - currentPosition.left + 60
#                   currentMon.animate(
#                    "left": "+=" + leftMove.toString()  + "px"
#                    "top": "+=" + topMove.toString()  + "px"
#                   , 250, ->
#                     action()
#                     checkMax()
#                     singleTargetAbilityDisplayVariable()
#                     if targetMon.css("display") isnt "none"
#                       if enemyHurt.isAlive() is false
#                         targetMon.css("transform":"scaleX(-1)").effect("explode", {pieces: 30}, 1000).hide()
#                       else
#                         targetMon.effect "shake", 750
#                   ).animate backPosition, 250, ->
#                     apChange()
#                     hpChangeBattle()
#                     showDamageSingle()
#                     checkMonHealthAfterEffect()
#                     toggleImg()
#                     flashEndButton()
#                     toggleEnemyClick()
#                     return
#                   return
#               when "targetenemy"
#                 toggleEnemyClick()
#                 $(".battle-guide.guide").text("Select an enemy target")
#                 $(".battle-guide").show()
#                 $(document).on "click.boom", ".enemy.mon-slot .img", ->
#                   disable(ability)
#                   singleTargetAbilityAfterClickDisplay()
#                   targetMon = $(this)
#                   monDiv = targetMon.parent()
#                   window.targets = targets.concat(monDiv.data("index"))
#                   targetPosition = $(this).data("position")
#                   abilityAnime = $(".single-ability-img")
#                   singleTargetAbilityDisplayVariable()
#                   abilityAnime.css(targetPosition)
#                   abilityAnime.attr("src", callAbilityImg).toggleClass "ability-on", ->
#                     action()
#                     if targetMon.css("display") isnt "none"
#                       if enemyHurt.isAlive() is false
#                         targetMon.css("transform":"scaleX(-1)").effect("explode", {pieces: 30}, 1000).hide()
#                       else
#                         targetMon.effect "shake", times: 10, 750
#                     element = $(this)
#                     checkMax()
#                     setTimeout (->
#                       element.toggleClass "ability-on"
#                       element.attr("src", "")
#                       showDamageSingle()
#                       singleTargetAbilityAfterActionDisplay()
#                       toggleEnemyClick()
#                       return
#                     ), 1200
#                     return
#               when "targetally", "ability"
#                 turnOffCommandA()
#                 toggleImg()
#                 $(".battle-guide.guide").text("Select an ally target")
#                 $(".battle-guide").show()
#                 $(document).on "click.help", ".user.mon-slot .img", ->
#                   $(document).off "click.help", ".user.mon-slot .img"
#                   toggleImg()
#                   disable(ability)
#                   singleTargetAbilityAfterClickDisplay()
#                   targetMon = $(this)
#                   monDiv = targetMon.parent()
#                   window.targets = targets.concat(monDiv.data("index"))
#                   targetPosition = $(this).data("position")
#                   abilityAnime = $(".single-ability-img")
#                   singleHealTargetAbilityDisplayVariable()
#                   abilityAnime.css(targetPosition)
#                   abilityAnime.attr("src", callAbilityImg).toggleClass "ability-on", ->
#                     targetMon.effect "bounce",
#                         distance: 100
#                         times: 1
#                       , 800
#                     element = $(this)
#                     action()
#                     checkMax()
#                     setTimeout (->
#                       element.toggleClass "ability-on"
#                       element.attr("src", "")
#                       showHealSingle()
#                       singleTargetAbilityAfterActionDisplay()
#                       turnOnCommandA()
#                       return
#                     ), 1200
#                     return
#               when "aoeenemy"
#                 $(document).off "click.cancel", ".cancel"
#                 disable(ability)
#                 $(".user .img").removeClass("controlling")
#                 ability.parent().parent().children(".abilityDesc").css "visibility", "hidden"
#                 abilityAnime = $(".ability-img")
#                 multipleTargetAbilityDisplayVariable()
#                 $(".ability-img").toggleClass "aoePositionFoe", ->
#                   element = $(this)
#                   element.attr("src", callAbilityImg).toggleClass("ability-on")
#                   setTimeout (->
#                     multipleAction()
#                     $(".enemy.mon-slot .img").each ->
#                       if $(this).css("display") isnt "none"
#                         if battle.players[1].mons[$(this).data("index")].isAlive() is false
#                           $(this).css("transform":"scaleX(-1)").effect("explode", {pieces: 30}, 1500).hide()
#                         else
#                           $(this).effect "shake", {times: 5, distance: 40}, 750
#                     element.toggleClass "ability-on aoePositionFoe"
#                     checkMax()
#                     showDamageTeam(1)
#                     singleTargetAbilityAfterActionDisplay()
#                     return
#                   ), 1200
#                   return
#               when "aoeally"
#                 toggleImg()
#                 $(document).off "click.cancel", ".cancel"
#                 disable(ability)
#                 $(".user .img").removeClass("controlling")
#                 ability.parent().parent().children(".abilityDesc").css "visibility", "hidden"
#                 abilityAnime = $(".ability-img")
#                 checkMin()
#                 multipleAction()
#                 checkMax()
#                 multipleTargetAbilityDisplayVariable()
#                 $(".ability-img").toggleClass "aoePositionUser", ->
#                   element = $(this)
#                   element.attr("src", callAbilityImg).toggleClass("ability-on")
#                   $(".user.mon-slot .img").each ->
#                       if battle.players[0].mons[$(this).data("index")].hp > 0
#                         $(this).effect "bounce",
#                           distance: 100
#                           times: 1
#                         , 800
#                   setTimeout (->
#                     element.toggleClass "ability-on aoePositionUser"
#                     element.attr("src", "")
#                     showHealTeam(0)
#                     singleTargetAbilityAfterActionDisplay()
#                     toggleImg()
#                     return
#                   ), 1200
#                   return
#               when "evolve"
#                 $(document).off "click.cancel", ".cancel"
#                 $(".user .img").removeClass("controlling")
#                 ability.remove()
#                 abilityAnime = $(".single-ability-img")
#                 targetMon = $(".0 .mon" + targets[1] + " " + ".img")
#                 betterMon = battle.players[0].mons[targets[1]].mon_evols[0]
#                 abilityAnime.css(targetMon.data("position"))
#                 abilityAnime.attr("src", betterMon.animation).toggleClass "ability-on", ->
#                   $(".battle").effect("shake")
#                   targetMon.fadeOut 500, ->
#                     $(this).attr("src", betterMon.image).fadeIn(1000)
#                 setTimeout (->
#                   battle.evolve(0, targets[1], 0)
#                   $(".0 .mon" + targets[1].toString() + " " + ".avatar").fadeOut(250).attr("src", betterMon.portrait).fadeIn(500)
#                   abilityAnime.toggleClass "ability-on"
#                   abilityAnime.attr("src", "")
#                   apChange()
#                   toggleImg()
#                   flashEndButton()
#                   return
#                 ), 2000
#                 return
#               else
#                 alert(".")
#         else
#           $(this).effect("highlight", {color: "red"}, 500)
#           $(".ap").effect("highlight", {color: "red"}, 500)
#           $(".end-turn").prop("disabled", false)






