class Application
  ENVIRONMENTS = %i[development test production].freeze
  INFLECTIONS = {
    'aws'    => 'AWS',
    'ebs'    => 'EBS',
    'ec2'    => 'EC2',
    'github' => 'GitHub',
    'iam'    => 'IAM',
    's3'     => 'S3',
    'war'    => 'WAR',
    'zip'    => 'ZIP'
  }

  def self.groups
    @groups ||= [
      ENV['WORKFLOW_ENVIRONMENT']&.split(',')&.map(&:to_sym)
    ].flatten.compact.keep_if { |env| ENVIRONMENTS.include? env }
  end
end
