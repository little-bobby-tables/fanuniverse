# frozen_string_literal: true
require_relative 'boot'

require 'rails/all'
require 'slim/include'

Bundler.require(*Rails.groups)

CORE_EXTENSIONS = File.expand_path('../../lib/core_ext/*.rb', __FILE__)
Dir.glob(CORE_EXTENSIONS, &method(:load))

class Application < Rails::Application
  config.active_job.queue_adapter = :sidekiq

  config.eager_load_paths << Rails.root.join('lib')
  config.eager_load_paths << Rails.root.join('app', 'models', 'validators')

  config.assets.enabled = false
  config.assets.compile = false

  Slim::Engine.set_options format: :html

  config.generators do |g|
    g.assets false
    g.view_specs true
    g.helper_specs false
    g.orm :active_record
    g.fixture_replacement :factory_girl
    g.javascript_engine :js
  end
end
