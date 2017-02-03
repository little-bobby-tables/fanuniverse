source 'https://rubygems.org'

# Server
gem 'rails', '~> 5.0.1'
gem 'puma'
# Database
gem 'pg'
gem 'postgres_ext', github: 'little-bobby-tables/postgres_ext', branch: 'rails-5'
# Image processing
gem 'carrierwave'
gem 'mini_magick'
# User management
gem 'devise'
gem 'corral_acl', require: 'corral', github: 'deliciousblackink/Corral'
# Front-end
gem 'slim-rails', github: 'slim-template/slim-rails'
gem 'sass-rails'
gem 'font-awesome-sass'
gem 'autoprefixer-rails'
gem 'normalize-rails'
gem 'yui-compressor'
gem 'closure-compiler'
gem 'babel-transpiler'
gem 'sprockets', '~> 4.0.0.beta4'

# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  #gem 'byebug', platform: :mri
  gem 'factory_girl_rails'
end

group :development do
  gem 'listen', '~> 3.0.5'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end
