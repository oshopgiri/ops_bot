# frozen_string_literal: true

Dir.glob(File.join(File.dirname(__FILE__), './initializers/**/*.rb')) do |initializer|
  require_relative initializer
end
