class DeployActions::GitHub
  def initialize(repo:)
    @repo = repo
  end

  def set_action_secret(name:, value:)
    system("gh secret set #{name} -a actions -b #{value} -R #{@repo}")
  end
end
