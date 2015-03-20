window.login = (callback) ->
  FB.login(callback, {scope: 'user_friends, email, publish_actions', return_scopes: true, display: "iframe"})
  return

window.loginCallback = (response) ->
  console.log 'loginCallback', response
  if response.status != 'connected'
    top.location.href = 'https://www.facebook.com/appcenter/YOUR_APP_NAMESPACE'
  return

window.onStatusChange = (response) ->
  if response.status != 'connected'
    login loginCallback
  else
    getMe ->
      getPermissions ->
        if hasPermission('user_friends')
          getFriends ->
            renderWelcome()
            # onLeaderboard()
            # showHome()
            return
        else
          renderWelcome()
          # showHome()
        return
      return
  return

window.onAuthResponseChange = (response) ->
  console.log 'onAuthResponseChange', response
  return

window.getMe = (callback) ->
  FB.api '/me', { fields: 'id,name,first_name,picture.width(120).height(120)' }, (response) ->
    if !response.error
      friendCache.me = response
      callback()
    else
      console.error '/me', response
    return
  return

window.renderWelcome = ->
  welcome = $('#welcome')
  welcome.find('.first_name').html(friendCache.me.first_name)
  welcome.find('.profile').attr('src', friendCache.me.picture.data.url)
  return


window.getFriends = (callback) ->
  FB.api '/me/friends', { fields: 'id,name,first_name,picture.width(120).height(120)' }, (response) ->
    if !response.error
      friendCache.friends = response.data
      callback()
    else
      console.error '/me/friends', response
    return
  return

window.getNonPlayers = (callback) ->
  FB.api '/me/invitable_friends', { fields: 'id,name,first_name,picture.width(120).height(120), games_activity' }, (response) ->
    if !response.error
      friendCache.invitable_friends = response.data
      callback()
    else
      console.error '/me/friends', response
    return
  return

window.getPermissions = (callback) ->
  FB.api '/me/permissions', (response) ->
    if !response.error
      friendCache.permissions = response.data
      callback()
    else
      console.error '/me/permissions', response
    return
  return


window.hasPermission = (permission) ->
  for i of friendCache.permissions
    if friendCache.permissions[i].permission == permission and friendCache.permissions[i].status == 'granted'
      return true
  false

window.reRequest = (scope, callback) ->
  FB.login callback,
    scope: scope
    auth_type: 'rerequest'
  return

window.sendInvite = (to, message, callback) ->
  players = []
  i = 0 
  while i < friendCache.invitable_friends.length
    players.push(friendCache.invitable_friends[i].id)
    i++
  options = { display: "popup", method: 'apprequests', filters: [ {name:'Suggested Users', user_ids:players} ] }
  if to
    options.to = to
  if message
    options.message = message
  FB.ui options, (response) ->
    if callback
      callback response
    return
  return

window.onInvite = ->
  sendInvite null, "Check out Monbattle! It's so fun that it will blow your brain off!", (response) ->
    console.log(response)
    addRequestToken(response.request) 
    return
  return

# window.onInvite = ->
#   to = ""
#   i = 0
#   while i < friendCache.invitable_friends.length
#     if i <= 20
#       to += ',' if to != ""
#       to += friendCache.invitable_friends[i]["id"] 
#     i++
#   console.log(to)
#   sendChallenge to, "Check out Monbattle! It's so fun that it will blow your brain off!", (response) ->
#     console.log 'sendChallenge', response
#     return
#   return


window.sendBrag = (caption, picture_url, name, callback) ->
  FB.ui {
    method: 'feed'
    caption: caption
    picture: picture_url
    name: name
    display: "popup"
  }, callback
  return

window.monbattleShare = (caption, picture_url, name, callback) ->
  sendBrag caption, picture_url, name, ->
    callback()
    return
  return


# sendBrag = (caption, callback) ->
#   FB.ui {
#     method: 'feed'
#     caption: caption
#     picture: 'http://www.friendsmash.com/images/logo_large.jpg'
#     name: 'Checkout my Friend Smash greatness!'
#   }, callback
#   return


# window.onGameOverBrag = ->
#   sendBrag 'I just scored 100' + '! Think you can beat me?', ->
#     showHome()
#     return
#   return


window.showHome = ->
  console.log("Fight!")

window.sendScore = (score, callback) ->
  FB.api '/me/scores/', 'post', { score: score }, (response) ->
    if response.error
      console.error 'sendScore failed', response
    else
      console.log 'Score posted to Facebook', response
    callback()
    return
  return

window.getRequest = ->
  FB.api '/me/apprequests', (response) ->
    if response and !response.error
      addAcceptedInvites(response)
    else
    return

window.addAcceptedInvites = (stuff) ->
  array = []
  i = 0
  window.dick = stuff.data
  while i < stuff.data.length
    num = stuff.data[i].id.indexOf("_")
    key = stuff.data[i].id.slice(0,num)
    array.push(key)
    i++
  $.ajax
    url: "/add_accepted_request"
    method: "POST"
    data: {accepted_invites: array}
    success: () ->
      console.log("success")


window.addRequestToken = (token) ->
  $.ajax
    url: "/add_request_token"
    method: "POST"
    data: {request_token: token}
    success: () ->
      console.log("success")

$ ->
  if typeof friendCache is "undefined"
    FB.init
      appId: '1514420408809454'
      xfbml: true
      version: 'v2.2'
      frictionlessRequests: true
      status: true
      window.friendCache = {me: {}, reRequests: {}}
  FB.Event.subscribe 'auth.authResponseChange', onAuthResponseChange
  FB.Event.subscribe 'auth.statusChange', onStatusChange
  setTimeout (->
    if document.getElementsByClassName("sign-in").length is 0
      getNonPlayers(showHome)
      getRequest()
  ), 2000




