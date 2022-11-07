class OpsBot::Context
  include OpsBot::Concern::Renderable

  class << self
    attr_reader :env, :secrets, :utils
  end

  def self.build
    build_env
    build_secrets
    build_utils
  end

  private

    def self.build_env
      @env = JSON.parse(
        render(view_file: 'env.json.erb'),
        object_class: OpenStruct
      )
    end

    def self.build_secrets
      @secrets = JSON.parse(
        render(view_file: 'secrets.json.erb'),
        object_class: OpenStruct
      )
    end

    def self.build_utils
      @utils = JSON.parse(
        render(view_file: 'utils.json.erb'),
        object_class: OpenStruct
      )
    end
end
