# frozen_string_literal: true

class OpsBot::Integration::GitHub
  class AuthenticationError < StandardError
    def initialize
      super('The github.com token in GH_TOKEN is not set/no longer valid')
    end
  end

  class InconsistentSecretError < StandardError
    def initialize(name:)
      super("Failed to set secret: #{name}")
    end
  end

  def self.auth_test
    is_authenticated = system('gh auth status')
    raise AuthenticationError unless is_authenticated
  end

  attr_reader :repository

  def initialize(repository:)
    self.class.auth_test

    @repository = repository
  end

  def set_action_secret(name:, value:)
    return unless @repository

    result = system("gh secret set #{name} -a actions -b #{value} -R #{@repository}")
    Application.capture_exception(InconsistentSecretError.new(name:)) unless result
  end
end
