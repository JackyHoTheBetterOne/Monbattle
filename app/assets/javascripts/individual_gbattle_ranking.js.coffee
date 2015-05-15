# document.addEventListener 'DOMContentLoaded', (event) ->
#   console.log("whats going on")
#   return

window.solveUrl = (obj) ->  
  Object.keys(obj).map((k) ->
    item = obj[k]
    if item.constructor.name isnt "Array"
      encodeURIComponent(k) + '=' + encodeURIComponent(item)
    else 
      key = encodeURIComponent(k) + "%5B%5D="
      array_url = []
      i = 0 
      count = item.length
      while i < count 
        array_url.push(key + encodeURIComponent(item[i]))
        i++
      return array_url.join("&")
  ).join '&'

window.ajax_insane_style = (obj) ->
  checkFunction = (callback, args) ->
    callback(args) if typeof callback isnt "undefined"
  checkFunction(obj["before_send"])
  request = new XMLHttpRequest()
  url = obj["url"] 
  params = undefined
  true_url = undefined
  if typeof obj["url_params"] isnt "undefined"
    params = obj["url_params"] 
  else if typeof obj["form_data_params"] isnt "undefined"
    params = obj["form_data_params"]
  else 
    params = ""
  request.onreadystatechange = ->
    if request.readyState is XMLHttpRequest.DONE
      checkFunction(obj["complete_call"])
      status = request.status
      if status is 200
        checkFunction(obj["success_call"], request.responseText)
      else if status is 400
        checkFunction(obj["error_call"])
      else 
        checkFunction(obj["epic_fail_call"])
  method = obj["method"].toUpperCase()
  if method is "POST"
    request.setRequestHeader("Content-type", "application/x-www-form-urlencoded")  
    request.setRequestHeader("Content-length", params.length)
    request.setRequestHeader("Connection", "close")
    request.open("POST", url, true)
    request.send(params)
  else if method is "GET"
    true_url = if params.length > 0 then url + "?" + params else url
    request.open("GET", true_url, true)
    request.send()

document.addEventListener 'page:change', (event) ->
  if window.location.href.indexOf("guild_individual_leadership_board?") isnt -1
    window.loadXMLDoc = (friend_array) ->
      real_stuff = document.getElementsByClassName("individual-listing")[0]
      real_stuff.className += " magictime tinUpOut"
      setTimeout (->
        real_stuff.className = real_stuff.className.replace(" magictime tinUpOut", "")
        real_stuff.className = real_stuff.className += " magictime tinUpIn"
       ), 950
      setTimeout (->
        real_stuff.className = real_stuff.className.replace(" magictime tinUpIn", "")
      ), 2000
      names = []
      i = 0
      count = friend_array.length
      while i < count
        names.push(friend_array[i].name)
        i++
      names.push("admin")
      area_name = document.getElementById("guild-area-name").getAttribute("data-areaname")
      object = {
        area_name: area_name,
        summoner_names: names
      }
      window.nameArray = names
      url = window.location.origin + "/guild_individual_leadership_board?" + solveUrl(object)
      ajax_object = {
        url: window.location.origin + "/guild_individual_leadership_board",
        url_params: solveUrl(object),
        method: "GET",
        success_call: (response) ->
          console.log(response)
          page = document.createElement('div')
          page.innerHTML = response
          component = page.getElementsByClassName("individual-listing")[0]
          real_stuff.innerHTML = component.innerHTML
      }
      ajax_insane_style(ajax_object)
      # xmlhttp = undefined
      # xmlhttp = new XMLHttpRequest
      # xmlhttp.onreadystatechange = ->
      #   if xmlhttp.readyState is XMLHttpRequest.DONE
      #     if xmlhttp.status is 200
      #       console.log(xmlhttp.responseText)
      #       page = document.createElement('div')
      #       page.innerHTML = xmlhttp.responseText
      #       component = page.getElementsByClassName("individual-listing")[0]
      #       real_stuff.innerHTML = component.innerHTML
      #     else if xmlhttp.status is 400
      #       alert 'There was an error 400'
      #     else
      #       alert 'something else other than 200 was returned'
      #   return
      # xmlhttp.open 'GET', url, true
      # xmlhttp.send()
      # return
    friend_click = document.getElementsByClassName("title-individual-battles-count")[0]
    friend_click.addEventListener 'click', (event) ->
      element = this
      element.style.pointerEvents = 'none'
      element.style.transition = "0.3s"
      element.style.opacity = "0.5"
      getFriends()
      f = friendCache.friends
      loadXMLDoc(f)
      setTimeout (->
        element.style.pointerEvents = 'auto'
        element.style.opacity = "1"
      ), 2000




# window.onload = ->
#   console.log("whats going on")
#   return

