module OpsBot::Build
  class UnsupportedTypeError < StandardError
    def initialize(type:)
      msg = "Build type `#{type}` not supported (yet!)"
      super(msg)
    end
  end

  def self.new
    type = OpsBot::Context.env.build.type
    "#{self.name}::#{type.camelize}".constantize.new
  rescue NameError => e
    raise UnsupportedTypeError.new(type: type)
  end
end
