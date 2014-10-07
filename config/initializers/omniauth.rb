OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, ENV['464134073726426'], ENV['FACEBOOK_SECRET']
end