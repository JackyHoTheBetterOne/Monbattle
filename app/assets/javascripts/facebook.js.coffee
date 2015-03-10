window.login = (callback) ->
  FB.login(callback, {scope: 'user_friends, email'})
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

window.sendChallenge = (to, message, callback) ->
  options = {method: 'apprequests'}
  if to
    options.to = to
  if message
    options.message = message
  FB.ui options, (response) ->
    if callback
      callback response
    return
  return

window.onChallenge = ->
  sendChallenge null, 'My dick is dry! Come and suck it wet!', (response) ->
    console.log 'sendChallenge', response
    return
  return


$ ->
  window.friendCache = {me: {}, reRequests: {}}
  FB.init
  appId: '1514420408809454'
  frictionlessRequests: true
  status: true
  version: 'v2.2'
  FB.Event.subscribe 'auth.authResponseChange', onAuthResponseChange
  FB.Event.subscribe 'auth.statusChange', onStatusChange



