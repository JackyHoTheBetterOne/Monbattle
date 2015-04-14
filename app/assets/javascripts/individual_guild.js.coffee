$ ->
  $(".member-kick-button").on "click", ->
    object = $(this)
    $.ajax
      url: "/guilds/kick_member"
      method: "POST"
      data: {summoner_name: $(this).data("name")}
      error: ->
        alert("Can't kick this member! Maybe he belongs in this guild?!")
      success: ->
        $(object).parent().addClass("magictime holeOut")
        setTimeout (->
          $(object).parent().remove()
        ), 1000