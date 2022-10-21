require_relative '../config/boot.rb'

ebs_client = DeployActions::AWS::EBS.new
ebs_version_label = DeployActions::Utils.build_version

if ebs_client.version_exists?
  puts "Existing application version found on EBS: #{ebs_version_label}, skipping version creation..."
else
  puts 'Creating new EBS application version...'
  ebs_client.create_version

  if ebs_client.version_exists?
    puts "Created new EBS application version: #{ebs_version_label}"
  else
    puts 'Version creation failed. Check logs for errors.'
    exit(1)
  end
end

puts 'Deploying...'
ebs_client.deploy_version

if DeployActions::Utils.is_production_deploy?
  slack_client = DeployActions::Notification::Slack.new
  slack_client.notify(view_file: 'ebs_deploy.json.erb')
end

exit(0)
