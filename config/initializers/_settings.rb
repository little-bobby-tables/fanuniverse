# frozen_string_literal: true
require 'yaml'

# +Settings+ provides access to settings/application.yml through a hash.
# It supports environment-specific configuration (e.g. production.yml) -
# think config gem, only inherently smaller.

settings_file = YAML.load_file Rails.root.join('config', 'settings.yml')

default       = settings_file['default'] || {}
env_overrides = settings_file[Rails.env] || {}

Settings = default.merge(env_overrides)
