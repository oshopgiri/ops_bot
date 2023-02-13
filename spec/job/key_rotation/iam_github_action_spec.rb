require 'spec_helper'

RSpec.describe OpsBot::Job::KeyRotation::IAMGitHubAction, type: :job do
  let(:client_klass) { OpsBot::Integration::AWS::IAM }
  let(:github_client_klass) { OpsBot::Integration::GitHub }
  let(:slack_client_klass) { OpsBot::Notification::Slack }

  let(:github_client_instance_1) { github_client_klass.new(repository: 'user/test1') }
  let(:github_client_instance_2) { github_client_klass.new(repository: 'user/test2') }

  after do
    described_class.execute
  end

  describe '#perform' do
    let(:serviced_repos) { [github_client_instance_1.repository, github_client_instance_2.repository] }
    let(:new_access_key) { 
      OpenStruct.new({
        access_key_id: 'access_key_id',
        secret_access_key: 'secret_access_key'
      }) 
    }

    before do
      allow_any_instance_of(client_klass).to receive(:rotate_access_key).and_return(new_access_key)
    end

    it 'rotates the access key for github action IAM user' do
      expect_any_instance_of(client_klass).to receive(:rotate_access_key).once
    end

    it 'notifies slack' do
      expect_any_instance_of(slack_client_klass).to receive(:notify).with(template: 'key_rotation-iam_github_action.json.erb', payload: { new_access_key: new_access_key }).once
    end

    context 'when `serviced_repos` are present' do
      before do
        allow(OpsBot::Context.env.access_key).to receive(:serviced_repos).and_return(serviced_repos)
      end

      it 'updates all repositories' do
        expect(github_client_klass).to receive(:new).with(repository: serviced_repos.first).and_return(github_client_instance_1).ordered.once
        expect(github_client_instance_1).to receive(:set_action_secret).twice

        expect(github_client_klass).to receive(:new).with(repository: serviced_repos.second).and_return(github_client_instance_2).ordered.once
        expect(github_client_instance_2).to receive(:set_action_secret).twice
      end
    end
  end
end
