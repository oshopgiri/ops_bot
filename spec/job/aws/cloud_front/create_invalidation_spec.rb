# frozen_string_literal: true

require 'spec_helper'

RSpec.describe OpsBot::Job::AWS::CloudFront::CreateInvalidation, type: :job do
  let(:client_klass) { OpsBot::Integration::AWS::CloudFront }

  after do
    described_class.execute
  end

  describe '#perform' do
    it 'creates new invalidation' do
      expect_any_instance_of(client_klass).to receive(:create_invalidation).once
    end
  end
end
