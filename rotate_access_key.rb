require_relative './config/boot.rb'

iam_client = DeployActions::AWS::IAM.new
iam_client.rotate_access_key

exit(0)
