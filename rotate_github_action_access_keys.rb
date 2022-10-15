require_relative './config/boot.rb'

iam_client = DeployActions::AWS::IAM.new
slack_client = DeployActions::Slack.new

new_access_key = begin
	iam_client.rotate_access_key
rescue
	nil
end

if new_access_key.present?
	DeployActions::Utils.parsed_serviced_repos.each do |repo|
		github_client = DeployActions::GitHub.new(repo: repo)
		{
			'AWS_ACCESS_KEY_ID': new_access_key.access_key_id,
			'AWS_SECRET_ACCESS_KEY': new_access_key.secret_access_key
		}.each do |name, value|
			github_client.set_action_secret(
				name: name.to_s,
				value: value
			)
		end
	end
end

slack_client.notify(payload: [
	{
		'type': 'section',
		'text': {
			'type': 'mrkdwn',
			'text': 'Key rotation: *AWS IAM ~<>~ GitHub Actions*'
		}
	},
	{
		'type': 'section',
		'fields': [
			{
				'type': 'mrkdwn',
				'text': "*Logs:* <#{DeployActions::Utils.action_run_url}|#{DeployActions::Utils.action_run_name}>"
			},
			{
				'type': 'mrkdwn',
				'text': "*Status:* #{new_access_key.present? ? ':large_green_circle:' : ':red_circle:'}"
			}
		]
	}
])

exit(0)
