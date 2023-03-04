# frozen_string_literal: true

require 'spec_helper'

RSpec.describe OpsBot::Job::AWS::EBS::FetchLogs, type: :job do
  let(:client_klass) { OpsBot::Integration::AWS::EBS }

  after do
    described_class.execute
  end

  describe '#perform' do
    it 'retrieves logs' do
      expect_any_instance_of(client_klass).to receive(:retrieve_logs).once
    end
  end
end
