window.login = (callback) ->
  FB.login callback
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
    showHome()
  return

window.onAuthResponseChange = (response) ->
  console.log 'onAuthResponseChange', response
  return

$ ->
  FB.init
  appId: '1514420408809454'
  frictionlessRequests: true
  status: true
  version: 'v2.2'

  FB.Event.subscribe 'auth.authResponseChange', onAuthResponseChange
  FB.Event.subscribe 'auth.statusChange', onStatusChange