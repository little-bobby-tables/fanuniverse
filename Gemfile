# frozen_string_literal: true
source 'https://rubygems.org'

# https://github.com/ruby/openssl/issues/103
gem 'openssl'
# Server
gem 'rails', '~> 5.0.1'
gem 'puma'
gem 'secure_headers'
# Database
gem 'pg'
gem 'postgres_ext', github: 'little-bobby-tables/postgres_ext', branch: 'rails-5'
gem 'redis'
gem 'redis-rails'
# Record versioning
gem 'paper_trail'
# Search
gem 'kaminari' # Needs to be included before elasticfusion
gem 'elasticfusion', git: 'git@github.com:little-bobby-tables/elasticfusion'
# Image handling
gem 'carrierwave'
gem 'mini_magick'
gem 'image_metadata_scraper'
# Background processing
gem 'sidekiq', '5.0.0.beta2'
# User management
gem 'devise'
gem 'corral_acl', require: 'corral', github: 'deliciousblackink/Corral', branch: 'override-by-deny'
# Front-end
gem 'camo'
gem 'slim-rails', github: 'slim-template/slim-rails'

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
