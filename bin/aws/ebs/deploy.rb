require_relative '../config/boot.rb'

ebs_client = OpsBot::AWS::EBS.new
ebs_version_label = OpsBot::Context.utils.build.version

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

if OpsBot::Context.utils.workflow.is_production?
  slack_client = OpsBot::Notification::Slack.new
  slack_client.notify(template: 'aws-ebs-deploy.json.erb')
end

exit(0)
