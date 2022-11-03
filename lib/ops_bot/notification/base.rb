class OpsBot::Notification::Base
  include OpsBot::Concerns::Renderable

  def notify(template:, payload:)
    raise 'method definition missing!'
  end
end
