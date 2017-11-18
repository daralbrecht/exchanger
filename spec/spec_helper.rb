ENV['RACK_ENV'] = 'test'

require 'simplecov'
require 'webmock/rspec'
require 'database_cleaner'

SimpleCov.start

require_relative '../config/environment'
require_relative 'fixtures/ecb/example_responses'

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end
  config.before { DatabaseCleaner.start }
  config.after { DatabaseCleaner.clean }
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :active_record
    with.library :active_model
  end
end

WebMock.disable_net_connect!(allow_localhost: true)
