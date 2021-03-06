$ ->
  $(document).off("click.learn", ".go-ahead-learn")
  $(document).off("click.learning-search", ".learning-search-cross")
  window.purchaseLearning = {}
  $(".teaching-info-icon").on("mouseover", ->
    teaching = document.getElementsByClassName("teaching-explanation")[0]
    teaching.style["z-index"] = "100"
    teaching.style["opacity"] = "1"
  ).on "mouseleave", ->
    teaching = document.getElementsByClassName("teaching-explanation")[0]
    teaching.style["opacity"] = "0"
    setTimeout (->
      teaching.style["z-index"] = "-1"
    ), 350
  $(document).on "click.learning-search", ".learning-search-cross", ->
    document.getElementsByClassName("ability-learning-search-words")[0].value = ""
    setTimeout (->
      document.getElementsByClassName("ability-learning-search")[0].click()
    ), 250
  $(document).on "mouseover", ".abilities-to-learn .ability-icon", ->
    document.getElementsByClassName("name")[0].innerHTML = $(this).data("name")
    document.getElementsByClassName("class-list")[0].innerHTML = $(this).data("classes")
    if $(this).data("slot") is 1
      document.getElementsByClassName("slot")[0].innerHTML = "Attack"
    else 
      document.getElementsByClassName("slot")[0].innerHTML = "Skill"
    if $(this).data("sign") is "-"
      document.getElementsByClassName("attack-icon-learn")[0].
        setAttribute("src", "https://s3-us-west-2.amazonaws.com/monbattle/images/attack-25px.png")
    else
      document.getElementsByClassName("attack-icon-learn")[0].
        setAttribute("src", "https://s3-us-west-2.amazonaws.com/monbattle/images/heal-25px.png")
    document.getElementsByClassName("ap-cost")[0].innerHTML = $(this).data("ap")
    document.getElementsByClassName("impact")[0].innerHTML = $(this).data("impact")
    document.getElementsByClassName("detail-description")[0].innerHTML = $(this).data("description")
  $(document).on "click.learning", ".ability-icon", ->
    ability = $(this)
    if $(this).attr("class").indexOf("ability-selected-to-learn") is -1
      purchaseLearning.ability_id = $(ability).data("id")
      purchaseLearning.ability_name = $(ability).data("name")
      purchaseLearning.ability_slot = $(ability).data("slot")
      if document.getElementsByClassName("ability-selected-to-learn").length isnt 0
        document.getElementsByClassName("ability-selected-to-learn")[0].className = "ability-icon"
      $(ability).addClass("ability-selected-to-learn")
  $(document).on "click.bestowing", ".mon-avatar", ->
    purchaseLearning.monster_id = $(this).data("id")
    purchaseLearning.monster_name = $(this).data("name")
    document.getElementsByClassName("learning-overlay")[0].style["z-index"] = "10000"
    document.getElementsByClassName("learning-overlay")[0].style.opacity = "1"
    document.getElementsByClassName("message-line")[0].innerHTML = 
      "Are you sure you want to teach " + purchaseLearning.ability_name + " to " + 
      purchaseLearning.monster_name + "?"
  $(document).on "click.cancel", ".cancel-learn", ->
    document.getElementsByClassName("learning-overlay")[0].style.opacity = "0"
    setTimeout (->
      document.getElementsByClassName("learning-overlay")[0].style["z-index"] = "-100"
    ), 400
  $(document).on "click.learn", ".go-ahead-learn", ->
    document.getElementsByClassName("warning-message")[0].style["opacity"] = "0"
    $.ajax 
      url: "/ability_purchases/" + purchaseLearning.ability_id
      method: "patch"
      data: {"learner_id": purchaseLearning.monster_id}
      success: (response) ->
        if response.indexOf("success") isnt -1
          slot = undefined
          if purchaseLearning.ability_slot is 1
            slot = "Attack"
          else 
            slot = "Skill"
          message = "To equip #{purchaseLearning.ability_name}, 
                     go to <a href='/home'>Edit Team</a>, then click on 
                     #{purchaseLearning.monster_name} and find it under the #{slot} slot!"
          if response.indexOf("first") isnt -1
            window.newAbilitiesLearned.push(message)
            hopscotch.startTour(ascension_tour)
          document.getElementsByClassName("success-message")[0].innerHTML = 
            purchaseLearning.monster_name + " has learned " + purchaseLearning.ability_name + "!"
          $(".mon-avatar").remove()
          $("#" + purchaseLearning.ability_id).remove()
          document.getElementsByClassName("student-list")[0].innerHTML = 
            "<h3> Select an ability to teach </h3>"
          document.getElementsByClassName("success-message")[0].style["opacity"] = "1"
          setTimeout (->
            document.getElementsByClassName("learning-overlay")[0].style.opacity = "0"
            setTimeout (->
              document.getElementsByClassName("learning-overlay")[0].style["z-index"] = "-100"
              document.getElementsByClassName("warning-message")[0].style["opacity"] = "1"
              document.getElementsByClassName("success-message")[0].style["opacity"] = "0"
              flashMaking()
              document.getElementsByClassName("path-but ability-learning-search")[0].
                click() if document.getElementsByClassName("ability-icon").length is 0
              setTimeout (->
                $(".teaching-info-icon").effect("shake")
              ), 300
            ), 400
          ), 800








