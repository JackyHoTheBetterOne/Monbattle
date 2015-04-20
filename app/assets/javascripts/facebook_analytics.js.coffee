window.facebookAnalytics = (object) ->
  console.log(object)
  FB.AppEvents.logEvent(
    FB.AppEvents.EventNames["#{object['eventName']}"],
    object["value"],  
    object["params"]
  )
