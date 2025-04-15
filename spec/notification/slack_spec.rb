# frozen_string_literal: true

require 'spec_helper'

RSpec.describe OpsBot::Notification::Slack, type: :notification do
  let(:client_klass) { ::Slack::Web::Client }

  describe '#notify' do
    let(:channel) { described_class::CHANNEL_NOTIFICATION }
    let(:instance) { described_class.new }

    before do
      allow(described_class).to receive(:render).and_return('')
      allow_any_instance_of(client_klass).to receive(:auth_test)

      allow(OpsBot::Context.env.slack.channels).to receive(:notification).and_return('test')
    end

    after do
      instance.notify(channel:, template: 'test.json.erb')
    end

    it 'authenticates the client' do
      expect_any_instance_of(client_klass).to receive(:auth_test)
    end

    it 'renders the payload' do
      expect_any_instance_of(client_klass).to receive(:chat_postMessage)
      expect(described_class).to receive(:render)
    end
  end
end
