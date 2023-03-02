class OpsBot::Integration::GitHub
  attr_reader :repository

  def initialize(repository:)
    @repository = repository
  end

  def set_action_secret(name:, value:)
    system("gh secret set #{name} -a actions -b #{value} -R #{@repository}")
  end
end
