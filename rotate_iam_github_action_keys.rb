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

payload = [
  {
    'type': 'header',
    'text': {
      'type': 'plain_text',
      'text': 'Key rotation',
      'emoji': true
    }
  }, {
    'type': 'divider'
  }, {
    'type': 'section',
    'text': {
      'type': 'plain_text',
      'text': 'AWS IAM :infinity: GitHub Actions',
      'emoji': true
    },
    'accessory': {
      'type': 'button',
      'text': {
        'type': 'plain_text',
        'text': 'Logs',
        'emoji': true
      },
      'style': new_access_key.present? ? 'primary' : 'danger',
      'url': DeployActions::Utils.action_run_url
    }
  }
]

payload << {
  'type': 'section',
  'text': {
    'type': 'mrkdwn',
    'text': '<!here|here>'
  }
} if new_access_key.blank?

slack_client.notify(payload: payload)

exit(0)
