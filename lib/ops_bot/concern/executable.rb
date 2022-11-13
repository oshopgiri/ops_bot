module OpsBot::Concern::Executable
  extend ActiveSupport::Concern

  class_methods do
    def execute
      result = perform
      result ? 0 : 1
    rescue
      1
    end
  end
end
