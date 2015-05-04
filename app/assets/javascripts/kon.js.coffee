$ ->
  # function onComplete () {
  #   window.kongregate = kongregateAPI.getAPI();
  # }
  # kongregateAPI.loadAPI(onComplete)
  console.log(window.kongregate = kongregateAPI.getAPI())
  $(".forest").prepend('<div>' + JSON.stringify(kongregateAPI) + '</div> <br />')
  $(".forest").prepend('<div>' + JSON.stringify(kongregate) + ' testing</div>')
  kongregate.services.showRegistrationBox()
  kongregateAPI.loadAPI()