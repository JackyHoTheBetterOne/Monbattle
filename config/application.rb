require File.expand_path('../boot', __FILE__)

# Pick the frameworks you want:
require "active_model/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Monbattle
  class Application < Rails::Application
    config.time_zone = 'Pacific Time (US & Canada)'
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
    config.autoload_paths += Dir[Rails.root.join('app', 'services', '*').to_s]
    config.paperclip_defaults = {
      :preserve_files => false,
      :storage => :s3,
      :s3_protocol => :https,
      :s3_host_name => "s3-us-west-2.amazonaws.com",
      :default_url => "https://s3-us-west-2.amazonaws.com/monbattle/images/frank.jpg",
      :s3_credentials => {:bucket => "monbattle",
        :access_key_id => ENV["AMAZON_ACCESS_KEY"],
        :secret_access_key => ENV["AMAZON_SECRET"]}
    }
  end
end
