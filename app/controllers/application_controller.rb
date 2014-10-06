class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception
  skip_before_filter :verify_authenticity_token

  before_action :configure_permitted_parameteres, if: :devise_controller?
  after_action :set_access_control_headers

  after_action :allow_iframe


  protected

  def allow_iframe
    response.headers.except! 'X-Frame-Options'
  end

  def configure_permitted_parameteres
    devise_parameter_sanitizer.for(:sign_up) << [:first_name, :last_name, :user_name]
    devise_parameter_sanitizer.for(:account_update) << [:first_name, :last_name]
  end

  private

  def set_access_control_headers
    headers['Access-Control-Allow-Origin']   = '*'
    headers['Access-Control-Request-Method'] = '*'
  end
end
