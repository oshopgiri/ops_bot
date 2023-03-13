# frozen_string_literal: true

class OpsBot::Integration::AWS::EC2::SecurityGroup
  def initialize(security_group_id:)
    @security_group_id = security_group_id
  end

  def revoke_old_ips(description_matcher:)
    existing_security_group_rule_ids = client
                                         .describe_security_group_rules(
                                           {
                                             filters: [
                                               {
                                                 name: 'group-id',
                                                 values: [@security_group_id]
                                               }
                                             ]
                                           }
                                         )
                                         .security_group_rules
                                         .select { |rule| rule.description.include? description_matcher }
                                         .map(&:security_group_rule_id)

    return unless existing_security_group_rule_ids.present?

    client
      .revoke_security_group_ingress(
        {
          group_id: @security_group_id,
          security_group_rule_ids: existing_security_group_rule_ids
        }
      )
  end

  def whitelist_ip(description:, ip_address:, port:, protocol:)
    client
      .authorize_security_group_ingress(
        {
          group_id: @security_group_id,
          ip_permissions: [
            {
              ip_protocol: protocol,
              ip_ranges: [
                {
                  cidr_ip: "#{ip_address}/32",
                  description:
                }
              ],
              from_port: port,
              to_port: port
            }
          ]
        }
      )
  end

  private

  def client
    @client ||= Aws::EC2::Client.new
  end
end
