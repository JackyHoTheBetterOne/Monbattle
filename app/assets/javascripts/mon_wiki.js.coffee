document.addEventListener 'page:change', (event) ->
  if window.location.href.indexOf("unique_monster_show") isnt -1
    MON_WIKI = {
      name: document.getElementsByClassName("monster-name")[0],
      rarity: document.getElementsByClassName("monster-rarity-type")[0],
      job: document.getElementsByClassName("monster-job-type")[0],
      skin: document.getElementsByClassName("viewing-monster-skin")[0],
      description: document.getElementsByClassName("monster-description")[0],
      designer: document.getElementsByClassName("designer-name")[0],
      share_button: document.getElementsByClassName("wiki-mon-share")[0]
      monster_array: ->
        return document.getElementsByClassName("wiki-monster-box")
      attach_viewing_event: ->
        share_button = MON_WIKI.share_button
        array = MON_WIKI.monster_array()
        i = 0
        while i < array.length
          selected_mon = array[i]
          selected_mon.addEventListener 'click', (event) ->
            selected_mon = this
            if window.getComputedStyle(selected_mon)["opacity"] is "1"
              $(".monster-viewing-box").effect("shake")
              Object.keys(MON_WIKI).map((k) ->
                viewing_box = MON_WIKI[k]
                if k isnt "monster_array" and k isnt "attach_viewing_event" and k isnt "share_button"
                  key_name = k
                  attribute_name = "data-" + k
                  if k is "skin"
                    url = selected_mon.getAttribute(attribute_name)
                    viewing_box.setAttribute("src", url)
                  else
                    viewing_box.innerHTML = selected_mon.getAttribute(attribute_name)
              )
              share_button.setAttribute("data-picture", selected_mon.getAttribute("data-skin"))
              caption = "I am looking at " + selected_mon.getAttribute("data-name") + " on Monbattle right now!"
              share_button.setAttribute("data-caption", caption)
              message = "I am gaining happiness as I play Monbattle!"
              share_button.setAttribute("data-message", message)
          i++
      attach_sharing_event: ->
        document.getElementsByClassName("wiki-mon-share")[0].addEventListener 'click', (event) ->
          button = this
          caption = this.getAttribute("data-caption")
          picture = this.getAttribute("data-picture")
          message = this.getAttribute("data-message")
          monbattleShare(caption, picture, message, showHome)
    }
    MON_WIKI.attach_viewing_event()
    MON_WIKI.attach_sharing_event()
