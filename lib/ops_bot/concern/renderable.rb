module OpsBot::Concern::Renderable
  extend ActiveSupport::Concern

  included do
    delegate :render, to: :class
  end

  class_methods do
    private

      def render(view_file:, context: render_context, instance: Object.new, payload: {})
        puts render_context
        render = Tilt.new("./templates/#{context}/#{view_file}").render(instance, payload)
        puts 'render'
        puts render
        render
      end

      def render_context
        @render_context ||= begin
          class_name = self.name.dup
          class_name.split('::')[1..].join('::').underscore
        end
      end
  end
end
