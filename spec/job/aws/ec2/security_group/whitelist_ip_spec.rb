require 'spec_helper'

RSpec.describe OpsBot::Job::AWS::EC2::SecurityGroup::WhitelistIP, type: :job do
  let(:client_klass) { OpsBot::Integration::AWS::EC2::SecurityGroup }

  after do
    described_class.execute
  end

  describe '#perform' do
    it 'revokes any existing IPs and whitelists the new IP' do
      expect_any_instance_of(client_klass).to receive(:revoke_old_ips).once
      expect_any_instance_of(client_klass).to receive(:whitelist_ip).once
    end
  end
end
