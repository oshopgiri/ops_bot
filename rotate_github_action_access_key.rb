require_relative './config/boot.rb'

iam_client = DeployActions::AWS::IAM.new
slack_client = DeployActions::Slack.new

status = begin
	iam_client.rotate_access_key
	true
rescue
	false
end
slack_client.notify(payload: [
	{
		'type': 'header',
		'text': {
			'type': 'plain_text',
			'text': 'IAM_:key::robot_face:',
			'emoji': true
		}
	},
	{
		'type': 'section',
		'text': {
			'type': 'mrkdwn',
			'text': '*AWS IAM :left_right_arrow: GitHub Actions*: Key rotation'
		}
	},
	{
		'type': 'section',
		'fields': [
			{
				'type': 'mrkdwn',
				'text': "*Status:* #{status ? ':heavy_check_mark:' : ':x:'}"
			},
			{
				'type': 'mrkdwn',
				'text': "*Logs:* <#{DeployActions::Utils.action_run_url}|#{DeployActions::Utils.action_run_name}>"
			}
		]
	}
])

exit(0)
