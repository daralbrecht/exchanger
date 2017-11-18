$stdout.sync = $stderr.sync = true
ENV['ENV'] ||= 'development'
require 'bundler'
Bundler.require :default, ENV['ENV']
require 'ostruct'
require 'logger'

# Load ENV configuration
Dotenv.load ".env.#{ENV['ENV']}", '.env'

# Initialize the Rails application.
module Exchanger
  Config = OpenStruct.new

  class << self
    def root
      @root ||= Pathname.new(File.dirname(__FILE__)).join('..').expand_path
    end

    def env
      @env ||= ENV['RACK_ENV']
    end

    attr_accessor :logger
  end

  self.logger = Logger.new(root.join('log', "#{env}.log"))

  Dir[root.join('config/initializers/**/*.rb')].each { |file| require file }
  Dir[root.join('app/models/*.rb')].each { |file| require file }
  Dir[root.join('app/services/*.rb')].each { |file| require file }

  $LOAD_PATH.unshift root.join('lib')

  require 'ecb/api'
  require 'extensions/string'
end
