# frozen_string_literal: true

ENV['APP_ENV'] ||= 'development'

require 'rubygems'
require 'bundler/setup'
require 'active_support'
require 'active_support/core_ext'

# don't break the require sequence here
require_relative './application'
require_relative './initializers'
require_relative './environment'
