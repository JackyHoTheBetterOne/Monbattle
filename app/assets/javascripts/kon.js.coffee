$ ->
  $("body").prepend('<p>' + JSON.stringify(kongregateAPI) + '</p>')
  kongregate = kongregateAPI.getAPI()
  $("body").prepend('<h3>' + JSON.stringify(kongregate) + ' testing</h3>')