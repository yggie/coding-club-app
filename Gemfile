source 'https://rubygems.org'
ruby '2.1.4'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.1.7'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.3'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer',  platforms: :ruby
gem 'rails_config'

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0',          group: :doc
# server-side markdown to html
gem 'redcarpet', '~> 3.2.0'
gem 'autoprefixer-rails', '~> 3.1.2'
gem 'bootstrap-sass', '~> 3.3.0.1'
gem 'devise', '~> 3.4.1'
gem 'omniauth-google-oauth2', '~> 0.2.6'
gem 'font-awesome-rails', '~> 4.2.0'

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]

group :development do
  gem 'letter_opener_web', '~> 1.2.3'
  gem 'binding_of_caller', '~> 0.7.2'
  gem 'better_errors', '~> 2.0.0'
end

group :development, :test do
  # Use sqlite3 as the database for Active Record
  gem 'sqlite3'
  gem 'factory_girl_rails', '~> 4.5.0'
  gem 'awesome_print', '~> 1.2.0'
  gem 'pry-byebug', '~> 2.0.0'
  gem 'pry-rails', '~> 0.3.2'
end

group :test do
  gem 'rspec-rails', '~> 3.1.0'
  gem 'shoulda-matchers', '~> 2.7.0'
end

group :production do
  gem 'rails_12factor', '~> 0.0.3'
  gem 'pg', '~> 0.17.0'
  gem 'puma', '~> 2.9.2'
end
