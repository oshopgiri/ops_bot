class Application
  ENVIRONMENTS = %i[development test production].freeze

  def self.groups
    @@groups ||= [:default, ENV['APP_ENV']&.split(',')&.map(&:to_sym)].flatten.compact.keep_if { |env| ENVIRONMENTS.include? env }
  end
end