ENV['APP_ENV'] ||= 'development'

require 'rubygems'
require 'bundler/setup'
require 'active_support'
require 'active_support/core_ext'

# don't break the require sequence here
require_relative './application.rb'
require_relative './initializers.rb'
require_relative './environment.rb'
