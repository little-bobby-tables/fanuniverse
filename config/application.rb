require_relative 'boot'

require 'rails/all'
require 'slim/include'

Bundler.require(*Rails.groups)

module StevenOnRails
  class Application < Rails::Application
    config.assets.enabled = false

    config.autoload_paths << Rails.root.join('lib')
    config.autoload_paths << Rails.root.join('app', 'models', 'validators')

    config.generators do |g|
      g.assets false
      g.view_specs true
      g.helper_specs false
      g.orm :active_record
      g.fixture_replacement :factory_girl
      g.javascript_engine :js
    end

    Slim::Engine.set_options format: :html
  end
end
