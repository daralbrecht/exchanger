source 'https://rubygems.org'

ruby '2.4.2'

gem 'activerecord', '5.1.4', require: 'active_record'
gem 'activerecord-import', '0.20.2'
gem 'dotenv', '2.2.1'
gem 'httparty', '0.15.6'
gem 'pg', '0.21.0'
gem 'rake', '12.3.0', require: false

group :development do
  gem 'guard-bundler', '2.1.0', require: false
  gem 'guard-rspec', '4.7.3', require: false
  gem 'guard-rubocop', '1.3.0', require: false
  gem 'rubocop-rspec', '1.20.1', require: false
end

group :development, :test do
  gem 'pry', '0.11.3'
  gem 'rspec', '3.7.0'
  gem 'shoulda-matchers', '3.1.2'
end

group :test do
  gem 'database_cleaner', '1.6.2'
  gem 'simplecov', '0.15.1', require: false
  gem 'webmock', '3.1.0'
end
