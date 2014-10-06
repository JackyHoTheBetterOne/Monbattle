class OmniauthCallbacksController < ApplicationController
  def facebook     
    oauth_data = request.env["omniauth.auth"].to_hash
    user = User.find_for_facebook_oauth(oauth_data)
    if user 
      sign_in user
      redirect_to root_path, notice: "Signed In Successfully!"
    else
      redirect_to root_path, alert: "Sorry! Couldn't sign you in"
    end
  end
end
