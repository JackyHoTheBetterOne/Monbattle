module ApplicationHelper

  def npc
    User.find_by_user_name("NPC")
  end

  def party_empty?(user)
    current_user.parties.first.empty?
  end

end