# frozen_string_literal: true

class Application
  ENVIRONMENTS = %i[development test production].freeze
  INFLECTIONS = {
    'aws' => 'AWS',
    'ebs' => 'EBS',
    'ec2' => 'EC2',
    'github' => 'GitHub',
    'iam' => 'IAM',
    'ip' => 'IP',
    's3' => 'S3',
    'war' => 'WAR',
    'zip' => 'ZIP'
  }.freeze

  class << self
    attr_accessor :exception_notifier, :loader, :logger

    delegate :capture_exception, to: :exception_notifier
    delegate :reload, to: :loader
  end

  def self.groups
    @groups ||= [
      ENV['APP_ENV']&.split(',')&.map(&:to_sym)
    ].flatten.compact.keep_if { |env| ENVIRONMENTS.include? env }
  end
end
