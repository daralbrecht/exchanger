config_path = File.join(File.dirname(__FILE__), '../database.yml')
ActiveRecord::Base.configurations = YAML.load_file(config_path)
ActiveRecord::Base.establish_connection(Exchanger.env.to_sym)
