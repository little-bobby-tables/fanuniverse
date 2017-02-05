source 'https://rubygems.org'

# Server
gem 'rails', '~> 5.0.1'
gem 'puma'
# Database
gem 'pg'
gem 'postgres_ext', github: 'little-bobby-tables/postgres_ext', branch: 'rails-5'
# Elasticsearch
gem 'elasticsearch'
gem 'elasticsearch-rails'
gem 'elasticsearch-model'
# Image processing
gem 'carrierwave'
gem 'mini_magick'
# User management
gem 'devise'
gem 'corral_acl', require: 'corral', github: 'deliciousblackink/Corral'
# Front-end
gem 'slim-rails', github: 'slim-template/slim-rails'

# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development do
  gem 'listen', '~> 3.0.5'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'rails-controller-testing'
  gem 'factory_girl_rails'
  gem 'faker'
end
