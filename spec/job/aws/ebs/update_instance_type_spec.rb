# frozen_string_literal: true

require 'spec_helper'

RSpec.describe OpsBot::Job::AWS::EBS::UpdateInstanceType, type: :job do
  let(:client_klass) { OpsBot::Integration::AWS::EBS }

  after do
    described_class.execute
  end

  describe '#perform' do
    it 'updates the instance type' do
      expect_any_instance_of(client_klass).to receive(:update_instance_type).once
    end
  end
end
