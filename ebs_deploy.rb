require_relative './config/boot.rb'

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
response = ebs_client.deploy_version

if DeployActions::Utils.is_production_deploy?
  payload = [
    {
      'type': 'header',
      'text': {
        'type': 'plain_text',
        'text': 'New deploy triggered',
        'emoji': true
      }
    }, {
      'type': 'divider'
    }, {
      'type': 'section',
      'text': {
        'type': 'plain_text',
        'text': "#{DeployActions::Utils.actor} :ship: #{DeployActions::Utils.ebs_application_name}[#{DeployActions::Utils.ebs_environment_name}]",
        'emoji': true
      },
      'accessory': {
        'type': 'button',
        'text': {
          'type': 'plain_text',
          'text': 'Logs',
          'emoji': true
        },
        'url': DeployActions::Utils.action_run_url
      }
    }, {
      'type': 'actions',
      'elements': [
        {
          'type': 'button',
          'text': {
            'type': 'plain_text',
            'text': "branch: #{DeployActions::Utils.branch_name}",
            'emoji': true
          },
          'url': DeployActions::Utils.branch_url
        }, {
          'type': 'button',
          'text': {
            'type': 'plain_text',
            'text': "ref: #{DeployActions::Utils.commit_reference}",
            'emoji': true
          },
          'url': DeployActions::Utils.commit_url
        }
      ]
    }
  ]

  slack_client = DeployActions::Slack.new
  slack_client.notify(payload: payload)
end

exit(0)
