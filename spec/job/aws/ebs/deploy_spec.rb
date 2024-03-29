# frozen_string_literal: true

require 'spec_helper'

RSpec.describe OpsBot::Job::AWS::EBS::Deploy, type: :job do
  let(:client_klass) { OpsBot::Integration::AWS::EBS }
  let(:slack_client_klass) { OpsBot::Notification::Slack }
  let(:s3_client_klass) { OpsBot::Integration::AWS::S3 }

  after do
    described_class.execute
  end

  describe '#perform' do
    before do
      allow_any_instance_of(client_klass).to receive(:deploy_version).and_return(true)
      # TODO: add specs around this
      allow_any_instance_of(s3_client_klass).to receive(:file_exists?).and_return(true)
    end

    context 'when application version is already present' do
      before do
        allow_any_instance_of(client_klass).to receive(:version_exists?).and_return(true)
      end

      it 'does not create a duplicate version' do
        expect_any_instance_of(client_klass).not_to receive(:create_version)
        expect_any_instance_of(client_klass).to receive(:deploy_version).once
      end
    end

    context 'when application version is not present' do
      before do
        allow_any_instance_of(client_klass).to receive(:version_exists?).and_return(false, true)
      end

      it 'creates and deploys a new version' do
        expect_any_instance_of(client_klass).to receive(:create_version).once
        expect_any_instance_of(client_klass).to receive(:deploy_version).once
      end

      context 'when version creation fails' do
        before do
          allow_any_instance_of(client_klass).to receive(:version_exists?).and_return(false, false)
        end

        it 'skips deployment' do
          expect_any_instance_of(client_klass).to receive(:create_version).once
          expect_any_instance_of(client_klass).not_to receive(:deploy_version)
        end
      end
    end

    context 'when deploying to production environment' do
      let(:notification_channel) { slack_client_klass::CHANNEL_NOTIFICATION }

      before do
        allow_any_instance_of(client_klass).to receive(:version_exists?).and_return(true)

        allow(OpsBot::Context.utils.workflow).to receive(:is_production?).and_return(true)
      end

      it 'notifies slack' do
        expect_any_instance_of(slack_client_klass)
          .to receive(:notify)
                .with(
                  channel: notification_channel,
                  template: 'aws-ebs-deploy.json.erb'
                ).once
      end
    end
  end
end
