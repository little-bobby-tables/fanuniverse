require_relative 'boot'

require 'rails/all'
require 'sprockets/railtie'
require 'slim/include'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module StevenOnRails
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.assets.enabled = true

    config.autoload_paths << Rails.root.join('lib')

    config.generators do |g|
      g.orm :active_record
      g.view_specs true
      g.helper_specs false
      g.fixture_replacement :factory_girl
      g.javascript_engine :js
    end

    Slim::Engine.set_options format: :html
  end
end
