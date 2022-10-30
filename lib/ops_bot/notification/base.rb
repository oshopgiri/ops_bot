class OpsBot::Notification::Base
  include OpsBot::Concerns::Renderable

  def notify(view_file:, payload:)
    raise 'method definition missing!'
  end
end
