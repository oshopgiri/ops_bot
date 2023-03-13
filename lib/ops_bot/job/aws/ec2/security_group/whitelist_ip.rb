# frozen_string_literal: true

class OpsBot::Job::AWS::EC2::SecurityGroup::WhitelistIP < OpsBot::Job::Base
  def self.perform
    security_group_client = OpsBot::Integration::AWS::EC2::SecurityGroup.new(
      security_group_id: OpsBot::Context.secrets.aws.ec2.security_group.id
    )

    security_group_client.revoke_old_ips(
      description_matcher: OpsBot::Context.utils.aws.ec2.security_group.rule.description
    )
    security_group_client.whitelist_ip(
      description: OpsBot::Context.utils.aws.ec2.security_group.rule.description,
      ip_address: OpsBot::Context.env.aws.ec2.security_group.rule.ip_address,
      port: OpsBot::Context.env.aws.ec2.security_group.rule.port,
      protocol: OpsBot::Context.env.aws.ec2.security_group.rule.protocol
    )

    true
  end
end
