window.tracking = (object) ->
  category = "design"   
  game_key = object["game_id"]
  secret_key = object["game_term"]
  message = {}
  message["user_id"] = object["user_id"]
  message["session_id"] = object["battle_id"]
  message["build"] = "1.00"
  if object["category"] is "frequency"
    message["event_id"] = object["event_id"]
    message["value"] = 1.0
  else if object["category"] is "duration"
    message["event_id"] = object["event_id"]
    message["value"] = object["value"]
  url = 'https://api.gameanalytics.com/1/'+game_key+'/'+category
  json_message = JSON.stringify(message)
  md5_msg = CryptoJS.MD5(json_message + secret_key)
  header_auth_hex = CryptoJS.enc.Hex.stringify(md5_msg)
  $.ajax
    type: "POST"
    url: url
    data: json_message
    headers:
      Authorization: header_auth_hex
    beforeSend: (xhr) ->
      xhr.setRequestHeader "Content-Type", "text/plain"
      return
    success: (data, textStatus, XMLHttpRequest) ->
      console.log "GOOD! textStatus: " + textStatus
      return
    error: (XMLHttpRequest, textStatus, errorThrown) ->
      console.log "ERROR ajax call. error: " + errorThrown + ", url: " + url
      return




