class OpsBot::AWS::EC2::SecurityGroup
  def initialize
    @description = DeployActions::Utils.ec2_security_group_rule_description
    @ip_address = OpsBot::Context.env.aws.ec2.security_group.rule.ip_address
    @port = OpsBot::Context.env.aws.ec2.security_group.rule.port
    @protocol = OpsBot::Context.env.aws.ec2.security_group.rule.protocol

    @security_group_id = OpsBot::Context.secrets.aws.ec2.security_group.id
  end

  def revoke_old_ips
    existing_security_group_rule_ids = client.describe_security_group_rules({
      filters: [{
        name: 'group-id',
        values: [@security_group_id]
      }]
    }).security_group_rules
    .select { |rule| rule.description.eql? @description }
    .map(&:security_group_rule_id)

    client.revoke_security_group_ingress({
      group_id: @security_group_id,
      security_group_rule_ids: existing_security_group_rule_ids
    }) if existing_security_group_rule_ids.present?
  end

  def whitelist_ip
    client.authorize_security_group_ingress({
      group_id: @security_group_id,
      ip_permissions: [{
        ip_protocol: @protocol,
        ip_ranges: [{
          cidr_ip: "#{@ip_address}/32",
          description: @description
        }],
        from_port: @port,
        to_port: @port
      }]
    })
  end

  private

    def client
      @client ||= Aws::EC2::Client.new
    end
end
