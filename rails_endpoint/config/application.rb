require_relative "boot"

require "rails"
require "action_controller/railtie"

Bundler.require(*Rails.groups)

module RailsEndpoint
  class Application < Rails::Application
    config.load_defaults 8.1
    config.api_only = true
  end
end
