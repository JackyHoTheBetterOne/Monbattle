# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  if window.location.href.indexOf("/guilds/new") is -1 && 
      window.location.href.indexOf("/guilds") isnt -1
    GUILD_LIST = {
      list: document.getElementsByClassName("guild-list")[0],
      search_field: document.getElementsByClassName("guild-search-field")[0],
      overlay: document.getElementsByClassName("single-guild-overlay")[0],
      overlay_box: document.getElementsByClassName("single-guild-for-view")[0],
      close_button: " <img src='https://s3-us-west-2.amazonaws.com/monbattle/images/cancel.png' 
                      class='single-guild-close-but'>"
      getListings: ->
        return document.getElementsByClassName("single-guild-listing")
      search_ajax: ->
        object = this
        $.ajax
          url: "/guilds",
          method: "GET",
          data: {
            guild_search: object.search_field.value,
          },
          error: ->
            alert("Cannot get guilds")
          success: (response) ->
            page = document.createElement('div')
            page.innerHTML = response
            component = page.getElementsByClassName("guild-list")[0]
            object.list.innerHTML = component.innerHTML
            i = 0
            array = object.getListings()
            console.log(array)
            while i < array.length
              array[i].className += " spaceInLeft magictime"
              i++
            return
    }
    $(".guild-search-send").on "click", (event) ->
      event.preventDefault()
      GUILD_LIST.search_ajax()
    $(document).off "click.further-guild-information"
    $(document).on "click.further-guild-information", ".further-guild-information", ->
      $.ajax
        url: "/guilds/" + $(this).data("name")
        error: ->
          alert("Can't get the guild's information")
        success: (response) ->
          page = document.createElement('div')
          page.innerHTML = response
          component = page.getElementsByClassName("individual-guild")[0]
          GUILD_LIST.overlay_box.innerHTML = component.innerHTML
          GUILD_LIST.overlay_box.innerHTML += GUILD_LIST.close_button
          overlay = GUILD_LIST.overlay
          overlay.style["z-index"] = "100000"
          overlay.style["opacity"] = "1"
          GUILD_LIST.overlay_box.className += " spaceInUp magictime"
          $(".single-guild-close-but").on "click", ->
            overlay.style["opacity"] = "0"
            setTimeout (->
              overlay.style["z-index"] = "-10"
              GUILD_LIST.overlay_box.className = "single-guild-for-view individual-guild"
            ), 500
    $(document).off "click.join-guild"
    $(document).on "click.join-guild", ".join-guild", ->
      button = $(this)
      object = {}
      object["type"] = $(this).data("type")
      object["information_object"] = {}
      object["information_object"]["guild_name"] = $(this).data("code")
      $.ajax
        url: "/notification_sending"
        method: 'POST'
        data: object
        error: ->
          alert("Can't send the guild request!")
        success: (response) ->
          $(button).fadeOut(500)
          













