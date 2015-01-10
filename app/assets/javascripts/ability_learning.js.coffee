$ ->
  window.purchaseLearning = {}
  $(document).on "mouseover", ".abilities-to-learn .ability-icon", ->
    document.getElementsByClassName("name")[0].innerHTML = $(this).data("name")
    if $(this).data("slot") is 1
      document.getElementsByClassName("slot")[0].innerHTML = "Attack"
    else 
      document.getElementsByClassName("slot")[0].innerHTML = "Ability"
    document.getElementsByClassName("ap-cost")[0].innerHTML = "AP: " + $(this).data("ap")
    document.getElementsByClassName("detail-description")[0].innerHTML = $(this).data("description")
  $(document).on "click.learning", ".ability-icon", ->
    ability = $(this)
    if $(this).attr("class").indexOf("ability-selected-to-learn") is -1
      purchaseLearning.ability_id = $(ability).data("id")
      purchaseLearning.ability_name = $(ability).data("name")
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
        if response is "success"
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
            ), 400
          ), 800








