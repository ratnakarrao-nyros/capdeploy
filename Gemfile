source 'https://rubygems.org'

gem 'rails', '3.2.13'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'pg'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
  gem 'jquery-datatables-rails'
end

gem 'jquery-rails'
gem 'pnotify-rails'
gem 'bootstrap-wysihtml5-rails'

# Authentication & Authorization
gem 'devise'
gem 'omniauth'
gem 'omniauth-facebook'
gem 'omniauth-twitter'
gem 'cancan'
## Reputation System
gem 'activerecord-reputation-system'
gem 'state_machine'

# others
gem 'configatron'
gem 'gravtastic'
gem 'rmagick'
gem 'carrierwave'
gem 'flash_cookie_session'
gem 'will_paginate'
gem 'high_voltage'
gem 'simple_form'
gem 'rabl'
gem 'gon'
gem 'coderay'
gem 'exception_notification', :group => :production
gem 'forum_monster'
gem 'newrelic_rpm' 
# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'
# gem 'thin'

gem 'passenger'
gem 'crash-watch'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'debugger'

group :development do
  gem 'letter_opener'
end

# development & testing purposes only
group :development, :test do
  gem 'pry-rails'
  gem 'rspec-rails'
  gem 'timecop'
  #gem 'rack-mini-profiler'
end

# the Fabricate onject will be used in the prodction mode to generate sample seed data
# the Faker::AddressUS::STATE will always be used in editing user profile state attribute
gem 'fabrication'
gem 'ffaker'

group :test do
  gem 'spork', '~> 0.9.0'
  gem 'guard-spork', '~> 0.5.2'
  gem 'guard-rspec'
  gem 'shoulda-matchers'
  gem 'capybara'
  gem 'database_cleaner'
  gem 'timecop'
  gem "rb-fsevent", :require => false
end
