$ ->
  kongregateAPI.loadAPI ->
    window.kongregate = kongregateAPI.getAPI()
  $("body").prepend('<p>' + JSON.stringify(kongregateAPI) + '</p>')
  $("body").prepend('<h3>' + JSON.stringify(kongregate) + ' testing</h3>')
  kongregate.services.showRegistrationBox()