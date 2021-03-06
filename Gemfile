source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.0'

# Use postgresql as the database for Active Record
gem 'pg'

# Use LESS for stylesheets
gem 'less-rails'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'

# See https://github.com/sstephenson/execjs#readme for more supported
# runtimes
gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'

# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

gem 'slim-rails'
gem 'devise'
gem 'carrierwave'
gem 'jquery-fileupload-rails'
gem 'remotipart'
gem 'cocoon'
gem 'skim'
gem 'twitter-bootstrap-rails'
gem 'private_pub'
gem 'thin'
gem 'responders'
gem 'omniauth'
gem 'omniauth-facebook'
gem 'omniauth-github'
gem 'omniauth-twitter'
gem 'cancancan'
gem 'doorkeeper'
gem 'active_model_serializers'
gem 'oj'
gem 'oj_mimic_json'
gem 'sidekiq'
gem 'whenever'
gem 'mysql2'
gem 'thinking-sphinx'
gem 'will_paginate'
gem 'dotenv'
gem 'dotenv-deployment', require: 'dotenv/deployment'
gem 'redis-rails'


# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
gem 'unicorn'

gem 'sinatra', '>= 1.3.0', require: nil

group :development do
  gem 'guard-foreman'
  gem 'guard-bundler', require: false

  gem 'letter_opener'
  gem 'capistrano', require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano-rails', require: false
  gem 'capistrano-rvm', require: false
  gem 'capistrano-sidekiq', require: false
  gem 'capistrano3-unicorn', require: false
end

group :development, :test do
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'selenium-webdriver'
  gem 'database_cleaner'

  # requires qt5-default libqt5webkit5-dev
  # requires JavaScript runtime (nodejs, therubyracer)
  gem 'capybara-webkit'

  # Call 'byebug' anywhere in the code to stop execution and get a debugger
  # console
  gem 'byebug'

  # Access an IRB console on exception pages or by using <%= console %> in
  # views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the
  # background. Read more: https://github.com/rails/spring
  gem 'spring'

  # A Ruby static code analyzer, based on the community Ruby style guide
  gem 'rubocop', require: false
end

group :test do
  gem 'shoulda-matchers'
  gem 'capybara'
  gem 'launchy'
  gem 'json_spec'
end
