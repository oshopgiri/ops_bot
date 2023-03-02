class OpsBot::Integration::AWS::IAM
  MAX_RETRIES = 5.freeze

  def initialize
    @access_key_id = OpsBot::Context.secrets.aws.access_key_id
    @user_name = OpsBot::Context.secrets.aws.iam.user_name
  end

  def deactivate_access_key
    return if existing_access_key_id.blank?

    try = 0
    begin
      sleep(10.seconds)

      new_client.update_access_key({
        access_key_id: existing_access_key_id,
        status: 'Inactive',
        user_name: @user_name
      })
    rescue
      try += 1
      retry if try < MAX_RETRIES
    end
  end

  def delete_access_key
    return if existing_access_key_id.blank?

    deactivate_access_key

    try = 0
    begin
      sleep(10.seconds)

      new_client.delete_access_key({
        access_key_id: existing_access_key_id,
        user_name: @user_name
      })
    rescue
      try += 1
      retry if try < MAX_RETRIES
    end
  end

  def generate_new_access_key
    client.create_access_key({
        user_name: @user_name
    }).access_key
  end

  def rotate_access_key
    @new_access_key = generate_new_access_key
    delete_access_key

    @new_access_key
  end

  private

    def client
      @client ||= Aws::IAM::Client.new
    end

    def new_client
      @new_client ||= Aws::IAM::Client.new(
        access_key_id: @new_access_key.access_key_id,
        secret_access_key: @new_access_key.secret_access_key
      )
    end

    def existing_access_key_id
      @existing_access_key_id ||= client.list_access_keys({
        user_name: @user_name
      }).access_key_metadata
      .map(&:access_key_id)
      .select { |access_key_id| access_key_id.eql? @access_key_id }
      .first
    end
end
