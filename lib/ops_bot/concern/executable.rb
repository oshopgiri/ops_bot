module OpsBot::Concern::Executable
  extend ActiveSupport::Concern

  class_methods do
    def execute
      result = perform
      puts 'result from perform'
      puts result
      result ? 0 : 1
    rescue
      1
    end
  end
end
