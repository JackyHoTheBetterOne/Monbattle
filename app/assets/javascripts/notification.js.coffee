$ ->
  NOTIFICATION_PACKAGE = {
    dropdown: document.getElementsByClassName("notification-dropdown")[0],
    toggle: document.getElementsByClassName("notification-toggle")[0],
    notifications: document.getElementsByClassName("individual-notification-inside-panel")
  }
  if NOTIFICATION_PACKAGE.notifications.length > 0 
    NOTIFICATION_PACKAGE.toggle.style["box-shadow"] = "0px 0px 15px yellow"
  else if NOTIFICATION_PACKAGE.dropdown
    message = document.getElementById("zero-notification-message")
    message.className += " no-notification-text"
  $(".notification-decision").on "click", ->
    div = $(this).parent()
    object = {}
    object["decision"] = $(this).data("judgement")
    object["code"] = $(div).data("code")
    $.ajax
      url: "/notification_action"
      data: object
      method: "POST"
      error: ->
        alert("Unable to process the notification")
      success: (response) ->
        $(div).children(".notification-title").text("")
        $(div).children(".notification-content").text(response).css("margin-top", "5px")
        $(div).children(".notification-decision").fadeOut(500)
  $(".notification-toggle").not(".guilds-page").on "click", ->
    dropdown = NOTIFICATION_PACKAGE.dropdown
    toggle = $(this)
    if window.getComputedStyle(dropdown, null)["opacity"] is "0"
      toggle.addClass("active-bar")
      dropdown.style["opacity"] = "1"
      dropdown.style["z-index"] = "1000000"
    else
      toggle.removeClass("active-bar")
      dropdown.style["opacity"] = "0"
      setTimeout (->
        dropdown.style["z-index"] = "-10"
      ), 500
  $(".for-real").on "click", ->
    NOTIFICATION_PACKAGE.toggle.className = "notification-toggle"
    dropdown = NOTIFICATION_PACKAGE.dropdown
    dropdown.style["opacity"] = "0"
    setTimeout (->
      dropdown.style["z-index"] = "-10"
    ), 500