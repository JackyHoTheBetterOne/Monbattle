$ ->
  $(".event_click").on "click", ->
    $.ajax 
      url: "/event_areas"
      method: "get"
      dataType: "json"
      error: ->
        alert("Cannot get events")
      success: (response) ->
        window.shit = response
        map = document.getElementsByClassName("battle_level")[0]
        map.style["opacity"] = 0
        setTimeout (->
          map.innerHTML = ""
        ), 350
        i = 0
        setTimeout (->
          while i < response.length
            filter_name = response[i].name.replace(" ", "+")
            normal_name = response[i].name
            banner = response[i].banner
            days_general = (new Date(response[i].end_date) - new Date().getTime())/(1000*60*60*24)
            hours = Math.floor((days_general - Math.floor(days_general))*24)
            days = Math.floor(days_general)

            event_html = 
              "<a class='event-panel' data-remote='true' href='/battles/new?level_filter=#{filter_name}&event=true'
               id='#{normal_name}'>

                <img src='#{banner}' class='event-banner'>
                <p class='time-left'>#{days} d #{hours} h left</p>

                <img src='https://s3-us-west-2.amazonaws.com/monbattle/images/clock.png' class='time-icon'>

               </a>" 
            map.innerHTML += event_html
            i++
          map.style["opacity"] = 1
        ), 400
        setTimeout (->
          $(".event-panel")[0].click()
        ), 800


# <a class="btn btn-primary map-level Forest of Solitude" data-remote="true" 
#   href="/battles/new?level_filter=Area+B" id="AreaB">Area B</a>






