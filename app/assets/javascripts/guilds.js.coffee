# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  if window.location.href.indexOf("/guilds/new") is -1 && 
      window.location.href.indexOf("/guilds") isnt -1
    GUILD_LIST = {
      list: document.getElementsByClassName("guild-list")[0],
      search_field: document.getElementsByClassName("guild-search-field")[0],
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