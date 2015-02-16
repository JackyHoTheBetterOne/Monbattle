class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  after_action :track_login, only: [:facebook]

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
      redirect_to new_user_registration_url
    end
  end

  private

  def track_login
    session_id = request.session_options[:id]
    @user.track_login(session_id)
  end
end
