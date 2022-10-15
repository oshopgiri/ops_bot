class DeployActions::AWS::Lambda
  def initialize
    @function_name = DeployActions::Utils.lambda_function_name
    @s3_bucket = DeployActions::Utils.s3_bucket_name
    @s3_key = DeployActions::Utils.s3_build_key
  end

  def update_function_code(publish: true)
    client.update_function_code({
      function_name: @function_name,
      s3_bucket: @s3_bucket,
      s3_key: @s3_key,
      publish: publish
    })
  end

  def invoke(payload:)
    client.invoke({
      function_name: @function_name,
      invocation_type: 'RequestResponse',
      log_type: 'Tail',
      payload: payload
    })
  end

  private

    def client
      @client ||= Aws::Lambda::Client.new
    end
end
