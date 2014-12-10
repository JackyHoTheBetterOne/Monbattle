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
end