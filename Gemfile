source 'https://rubygems.org'
git_source(:github) { |repo| 'https://github.com/#{repo}.git' }

ruby file: '.ruby-version'

gem 'rails', '~> 8.0.2'
gem "sqlite3", '>= 2.1'
gem 'sprockets-rails'
gem 'puma', '~> 6.4.0'
gem 'jsbundling-rails'
gem 'turbo-rails'
gem 'stimulus-rails'
gem 'jbuilder'
gem 'redis'

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem 'kredis'

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem 'bcrypt', '~> 3.1.7'
gem 'tzinfo-data', platforms: %i[ mingw mswin x64_mingw jruby ]
gem 'bootsnap', require: false

# Use Sass to process CSS
gem 'sassc-rails'
gem "bootstrap"

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
gem 'image_processing', '~> 1.2'

# Custom gems
gem 'devise'
gem 'ransack'
gem 'haml'
gem 'browser'
gem 'pry-rails'
gem 'font-awesome-sass'
gem 'simple_form'
gem 'geocoder'
gem 'rubocop-rails', require: false
gem 'acts_as_list'
gem 'pagy'
gem 'solid_queue'
gem 'mission_control-jobs'
gem 'litestream'
gem 'enumerize'
gem 'solid_cable'
gem 'solid_cache'

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem 'debug', platforms: %i[ mri mingw x64_mingw ]
  gem 'dotenv-rails'
  gem 'rspec-rails', '~> 6.0', '>= 6.0.3'
  gem 'factory_bot_rails'
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem 'web-console'
  gem 'bullet'

  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  gem 'rack-mini-profiler', require: false
  gem 'ruby-lsp-rails'
  gem "better_errors"
  gem "binding_of_caller"
  gem 'hotwire-spark'

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem 'spring'
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem 'capybara'
  gem 'selenium-webdriver'
end
