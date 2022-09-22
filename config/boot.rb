require 'rubygems'
require 'bundler/setup'
require 'active_support'
require 'active_support/core_ext'

Bundler.require(:default)

if ['development'].include? ENV['RUBY_ENV']
  Bundler.require(:development)
  Dotenv.load('.env', '.secrets')
end

loader = Zeitwerk::Loader.new
loader.push_dir('lib')
loader.inflector.inflect("aws" => "AWS")
loader.inflector.inflect("ebs" => "EBS")
loader.inflector.inflect("ec2" => "EC2")
loader.inflector.inflect("iam" => "IAM")
loader.inflector.inflect("s3" => "S3")
loader.setup
