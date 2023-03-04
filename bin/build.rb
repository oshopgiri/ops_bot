# frozen_string_literal: true

require 'pathname'
boot_script = File.join(
  Pathname.new('/').relative_path_from(Pathname.new("/#{File.dirname(__FILE__)}")).to_s,
  'config/boot.rb'
)
require_relative boot_script

exit(OpsBot::Job::Build.execute)
