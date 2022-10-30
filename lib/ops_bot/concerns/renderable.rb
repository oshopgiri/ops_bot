module OpsBot::Concerns::Renderable
  extend ActiveSupport::Concern

  included do
    delegate :render, to: :class
  end

  class_methods do
    private

      def render(view_file:, instance: Object.new, payload: {})
        Tilt.new("./templates/#{render_context}/#{view_file}").render(instance, payload)
      end

      def render_context
        class_name = self.name.dup
        class_name.split('::')[1..].join('::').underscore
      end
  end
end
