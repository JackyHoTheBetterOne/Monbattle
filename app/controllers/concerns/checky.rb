module Checky
  # extend ActiveSupport::Concern

  # included do 
  #   before_filter :check_unlock_code, except: [:facebook]
  # end

  # def check_unlock_code
  #   if current_user
  #     user = current_user
  #     if user.game_unlock == "" && current_user.admin == false
  #       flash[:warning] = "You gotta unlock the game first, dude!"
  #       redirect_to home_sweet_home_path
  #       return
  #     end
  #   else
  #     flash[:warning] = "Please log in first!"
  #     redirect_to home_sweet_home_path
  #     return 
  #   end
  # end
end