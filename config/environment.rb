$stdout.sync = $stderr.sync = true
ENV['ENV'] ||= 'development'
require 'bundler'
Bundler.require :default, ENV['ENV']
require 'ostruct'

# Initialize the application.
module Exchanger
  Config = OpenStruct.new

  class << self
    def root
      @root ||= Pathname.new(File.dirname(__FILE__)).join('..').expand_path
    end

    def env
      @env ||= ENV['ENV']
    end
  end

  Dir[root.join('config/initializers/**/*.rb')].each { |file| require file }
  Dir[root.join('app/models/*.rb')].each { |file| require file }
  Dir[root.join('app/services/*.rb')].each { |file| require file }

  $LOAD_PATH.unshift root.join('lib')

  require 'ecb/api'
  require 'extensions/string'
end
