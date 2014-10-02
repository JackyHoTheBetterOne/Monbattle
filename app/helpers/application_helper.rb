module ApplicationHelper

  def npc
    User.find_by_user_name("NPC")
  end


end