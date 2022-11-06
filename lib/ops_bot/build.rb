module OpsBot::Build
  def self.new
    type = OpsBot::Context.env.build.type
    "#{self.name}::#{type.camelize}".constantize.new
  end
end
