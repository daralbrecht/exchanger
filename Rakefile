require 'yaml'
require 'active_record'

include ActiveRecord::Tasks

root = File.expand_path '..', __FILE__
DatabaseTasks.env = ENV['ENV'] || 'development'
DatabaseTasks.database_configuration =
  YAML.safe_load(File.read(File.join(root, 'config/database.yml')))
DatabaseTasks.db_dir = File.join root, 'db'
DatabaseTasks.fixtures_path = File.join root, 'test/fixtures'
DatabaseTasks.migrations_paths = [File.join(root, 'db/migrate')]
DatabaseTasks.root = root

task :environment do
  require File.join(File.dirname(__FILE__), 'config/environment')
end

load 'active_record/railties/databases.rake'

Dir[File.join(File.dirname(__FILE__), 'lib/tasks/**/*.rb')].each { |task| require task }
