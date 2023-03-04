# frozen_string_literal: true

require 'spec_helper'

RSpec.describe OpsBot::Notification::Slack, type: :notification do
  let(:client_klass) { ::Slack::Web::Client }

  describe '#initialize' do
    after do
      described_class.new
    end

    it 'verifies authentication with Slack' do
      expect_any_instance_of(client_klass).to receive(:auth_test)
    end
  end

  describe '#notify' do
    let(:instance) { described_class.new }

    before do
      allow_any_instance_of(client_klass).to receive(:auth_test)
      allow(OpsBot::Context.env.slack).to receive(:channel_ids).and_return('test')
    end

    after do
      instance.notify(template: 'test.json.erb')
    end

    it 'renders the payload' do
      expect_any_instance_of(client_klass).to receive(:chat_postMessage)
      expect(described_class).to receive(:render)
    end
  end
end
