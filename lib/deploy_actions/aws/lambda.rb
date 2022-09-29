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
    response = client.invoke({
      function_name: @function_name,
      invocation_type: 'RequestResponse',
      log_type: 'Tail',
      payload: payload
    })

    return response.status_code.eal?(200), response.payload
  end

  private

    def client
      @client ||= Aws::Lambda::Client.new
    end
end
