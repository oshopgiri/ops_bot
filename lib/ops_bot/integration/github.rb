class OpsBot::Integration::GitHub
  attr_reader :repository

  def initialize(repository:)
    is_authenticated = system('gh auth status')
    @repository = is_authenticated ? repository : nil
  end

  def set_action_secret(name:, value:)
    return unless @repository
    system("gh secret set #{name} -a actions -b #{value} -R #{@repository}")
  end
end
