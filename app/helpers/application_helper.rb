module ApplicationHelper

  def npc
    User.find_by_user_name("NPC")
  end

  def is_npc(user)
    User.where(id: user).exists?
  end

end