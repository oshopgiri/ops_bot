require_relative './config/boot.rb'

lambda_client = DeployActions::AWS::Lambda.new
lambda_client.update_function_code

exit(0)
