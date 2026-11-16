require_relative "boot"
require "rails/all"

Bundler.require(*Rails.groups)

module EmployeeManagementApp
  class Application < Rails::Application
    config.load_defaults 7.1
    config.time_zone = "Asia/Kolkata"
    config.i18n.default_locale = :en
  end
end
