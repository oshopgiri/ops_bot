class OpsBot::Context
  include OpsBot::Concerns::Renderable

  class << self
    attr_reader :env, :secrets
  end

  def self.build
    build_env
    build_secrets
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
end
