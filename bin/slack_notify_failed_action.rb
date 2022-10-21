slack_client = DeployActions::Notification::Slack.new
slack_client.notify(view_file: 'notify_failed_action.json.erb')

exit(0)