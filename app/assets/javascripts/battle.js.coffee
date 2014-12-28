# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

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
        if battle.start_cut_scenes.length isnt 0 
          $(".cutscene").show(500)
          toggleImg()
          nextSceneInitial(1000)
        else 
          $(document).off "click.cutscene", "#overlay"
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


