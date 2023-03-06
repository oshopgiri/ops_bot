# frozen_string_literal: true

module OpsBot::Build
  class UnsupportedTypeError < StandardError
    def initialize(type:)
      super("Build type `#{type}` not supported (yet!)")
    end
  end

  def self.new
    type = OpsBot::Context.env.build.type
    "#{name}::#{type.camelize}".constantize.new
  rescue NameError => e
    raise UnsupportedTypeError.new(type: type)
  end
end
