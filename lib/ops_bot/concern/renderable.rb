module OpsBot::Concern::Renderable
  extend ActiveSupport::Concern

  included do
    delegate :render, to: :class
  end

  class_methods do
      def render(view_file:, context: render_context, instance: Object.new, payload: {})
        render = Tilt.new("./templates/#{context}/#{view_file}").render(instance, payload)
        puts 'render'
        puts render
        render
      end

      def render_context
        puts 'pre render_context'
        puts self.name.dup
        puts self.name.dup.split('::')[1..].join('::').underscore

        @render_context ||= begin
          class_name = self.name.dup
          class_name.split('::')[1..].join('::').underscore
        end

        puts 'render_context'
        puts @render_context
        @render_context
      end
  end
end
