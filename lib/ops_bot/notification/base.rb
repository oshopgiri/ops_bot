# frozen_string_literal: true

class OpsBot::Notification::Base
  include OpsBot::Concern::Renderable

  def notify(template:, payload:)
    raise 'method definition missing!'
  end
end
