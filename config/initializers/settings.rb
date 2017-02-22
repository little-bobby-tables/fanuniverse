require 'yaml'

# +Settings+ provides access to settings/application.yml through a hash.
# It supports environment-specific configuration (e.g. production.yml) —
# think config gem, only inherently smaller.

def settings_path(level = 'application')
  Rails.root.join('config', 'settings', "#{level}.yml")
end

Settings = YAML.load_file(settings_path).tap do |settings|
  if File.exists? settings_path(Rails.env)
    settings.merge! YAML.load_file(settings_path(Rails.env))
  end
end
