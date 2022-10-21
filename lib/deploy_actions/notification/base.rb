class DeployActions::Notification::Base
  def notify(view_file:, payload:)
    raise 'method definition missing!'
  end

  private

    def parse(view_file:, payload:)
      render(
        context: view_source,
        view_file: view_file,
        instance: self,
        payload: payload
      )
    end

    def view_source
      "views/notification/#{self.class.name.demodulize.underscore}"
    end
end