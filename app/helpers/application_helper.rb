module ApplicationHelper

  def npc
    User.find_by_user_name("NPC")
  end

  def party_empty?(user)
    current_user.parties.first.empty?
  end

  def dateTime(time)
    time.strftime("Created at %I:%M%p %m/%d/%Y")
  end

  def seconds_to_time(seconds)
    Time.at(seconds).utc.strftime("%H:%M:%S")
  end

  def current_summoner
    return current_user.summoner
  end

  def current_led_guild
    summoner = current_user.summoner
    if summoner.led_guild
      return summoner.led_guild
    elsif summoner.sub_led_guild
      return summoner.sub_led_guild
    else 
      return false
    end
  end

  def current_guild
    current_user.summoner.guild
  end
end