class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  after_action :track_login, only: [:facebook]
  after_action :quest_start, only: [:facebook]

  def facebook     
    @user = User.find_for_facebook_oauth(request.env["omniauth.auth"], current_user)      
    if @user.persisted?       
      sign_in @user, :event => :authentication #this will throw if @user is not activated
      set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
      if @user.summoner.played_levels.count == 0 
        redirect_to create_battle_path
      else
        redirect_to new_battle_path 
      end
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
    end
  end

  private

  def track_login
    session_id = request.session_options[:id]
    time = Time.now.in_time_zone("Pacific Time (US & Canada)").strftime("%A %H")
    @user.track_login(session_id, time)
  end

  def quest_start
    if current_user
      @date = Time.now.in_time_zone("Pacific Time (US & Canada)").to_date
      @party = current_user.parties[0]
      if Battle.find_matching_date(@date, @party).count == 0
        @party.user.summoner.quest_begin 
        @party.user.summoner.clear_daily_achievement
        @party.user.summoner.clear_daily_battles
      end
    end
  end
end


# set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?