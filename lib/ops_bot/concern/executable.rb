# frozen_string_literal: true

module OpsBot::Concern::Executable
  extend ActiveSupport::Concern

  class_methods do
    def execute
      tags
      result = perform
      result ? 0 : 1
    rescue => e
      Application.capture_exception(e)
      1
    end
  end
end
