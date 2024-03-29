# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.3'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.3'
# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'
# Use Puma as the app server
gem 'puma', '~> 3.11'
# Use SCSS for stylesheets
# gem 'sass-rails', '~> 5.0'
gem 'sassc-rails'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'mini_racer', platforms: :ruby

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# Turbolinks makes navigating your web application faster.
# Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

gem 'config' # Easy application settings via yaml

gem 'devise' # User authenticaiton
gem 'pundit' # User authorization

gem 'draper' # Decorator pattern

gem 'activeadmin' # Easy front end into active_record

gem 'active_record-acts_as' # Simulates multi table inheritance

gem 'rest-client' # RESTful wrapper for http requests

gem 'paper_trail' # Tracks versions and changes to things
gem 'paper_trail-association_tracking' # Gives PT associations tracking

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

gem 'factory_bot_rails' # Creates factories for models
gem 'faker'

gem 'coveralls', require: false # code coverage

group :test do
  gem 'capybara' # For integration testing.
  gem 'selenium-webdriver' # Web page interaction
  gem 'shoulda-matchers' # Really handy RSpec matchers
  gem 'webmock' # Allows mocking of web apis for instance
end

group :development, :test do
  gem 'database_cleaner'                  # Allows isolated testing of DB interactions.
  gem 'rspec-rails'                       # Rspec
  # gem 'shoulda-matchers'         # Really handy RSpec matchers
  gem 'spring-commands-rspec', group: :development
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
end

group :development do
  # Access an interactive console on exception pages or by calling 'console'
  # anywhere in the code.
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'web-console', '>= 3.3.0'
  # Spring speeds up development by keeping your application running in the
  # background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
# gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]bu
