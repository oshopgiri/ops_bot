class DeployActions::AWS::IAM
  def initialize
    @user_name = DeployActions::Utils.iam_user_name
    @serviced_repos = DeployActions::Utils.parsed_serviced_repos
  end

  def rotate_access_key
    existing_access_key_ids

    @new_access_key = client.create_access_key({
        user_name: @user_name
    }).access_key

    @serviced_repos.each do |repo|
      rotate_repo_access_keys(
        repo: repo,
        new_access_key: @new_access_key
      )
    end

    existing_access_key_ids.each do |access_key_id|
      delete_existing_access_key(access_key_id: access_key_id)
    end
  end

  private

    def client
      @client ||= Aws::IAM::Client.new
    end

    def custom_client
      @custom_client ||= Aws::IAM::Client.new(
        access_key_id: @new_access_key.access_key_id,
        secret_access_key: @new_access_key.secret_access_key
      )
    end

    def delete_existing_access_key(access_key_id:)
      sleep(5.seconds)

      custom_client.update_access_key({
        access_key_id: access_key_id,
        status: 'Inactive',
        user_name: @user_name
      })

      sleep(5.seconds)

      custom_client.delete_access_key({
        access_key_id: access_key_id,
        user_name: @user_name
      })
    end

    def existing_access_key_ids
      @existing_key_ids ||= client.list_access_keys({
        user_name: @user_name
      }).access_key_metadata
      .map(&:access_key_id)
    end

    def rotate_repo_access_keys(repo:, new_access_key:)
      system("gh secret set AWS_ACCESS_KEY_ID -a actions -b #{new_access_key.access_key_id} -R #{repo}")
      system("gh secret set AWS_SECRET_ACCESS_KEY -a actions -b #{new_access_key.secret_access_key} -R #{repo}")
    end
end
