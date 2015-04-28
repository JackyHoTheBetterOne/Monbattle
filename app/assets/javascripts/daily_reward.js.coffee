$ ->
  daily_reward_timer = {
    timer: document.getElementsByClassName("daily-reward-timer")[0],
    reward_overlay: document.getElementsByClassName("daily-reward-overlay")[0],
    count_down: ->
      timer = document.getElementsByClassName("daily-reward-timer")[0]
      reward_overlay = document.getElementsByClassName("daily-reward-overlay")[0]
      reward_amount = document.getElementsByClassName("daily-reward-number")[0]
      reward_icon = document.getElementsByClassName("daily-reward-logo")[0]
      reward_box = document.getElementsByClassName("daily-reward-screen")[0]
      reward_message = document.getElementsByClassName("daily-reward-message")[0]
      seconds = parseInt(timer.innerHTML)
      if seconds >= 0
        seconds -= 1 if seconds isnt 0 
        if seconds == 0
          console.log("wtf is going on")
          $.ajax
            url: "/giving_daily_reward.json"
            dataType: "json"
            method: "get"
            error: ->
              alert("Daily reward giving failure")
            success: (response) ->
              console.log(response)
              reward_amount.innerHTML = response.amount
              reward_icon.setAttribute("src", response.icon)
              reward_overlay.style["background"] = "rgba(0,0,0,0.9)"
              reward_overlay.style["opacity"] = "1"
              reward_overlay.style["z-index"] = "1000000"
              reward_box.className += " magictime boingInUp"
              if response.type is "first"
                reward_message.innerHTML = "Second reward incoming"
                timer.innerHTML = 100
              else 
                reward_message.innerHTML = "Come back tomorrow for more"
                timer.innerHTML = -10 
                setTimeout (->
                  window.clearInterval(dailyRewardGivingTimer)
                  $(".daily-reward-timer-box").remove()
                ), 500
        else 
          timer.innerHTML = seconds
  }
  window.clearInterval(dailyRewardGivingTimer) if typeof window.dailyRewardGivingTimer isnt "undefined"
  if daily_reward_timer.timer
    window.dailyRewardGivingTimer = setInterval(daily_reward_timer.count_down, 1000)
  $(".daily-reward-screen-close").on "click", ->
    document.getElementsByClassName("daily-reward-screen")[0].className = "daily-reward-screen"
    overlay = daily_reward_timer.reward_overlay
    overlay.style["opacity"] = "0"
    setTimeout (->
      overlay.style["z-index"] = "-1"
    ), 500








