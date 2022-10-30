loader = Zeitwerk::Loader.new
loader.push_dir('lib')
loader.inflector.inflect("aws" => "AWS")
loader.inflector.inflect("ebs" => "EBS")
loader.inflector.inflect("ec2" => "EC2")
loader.inflector.inflect("github" => "GitHub")
loader.inflector.inflect("iam" => "IAM")
loader.inflector.inflect("s3" => "S3")
loader.inflector.inflect("war" => "WAR")
loader.inflector.inflect("zip" => "ZIP")
loader.setup
