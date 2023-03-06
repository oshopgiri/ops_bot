# frozen_string_literal: true

class CustomInflector < Zeitwerk::Inflector
  def camelize(basename, _abspath)
    overrides[basename] || basename.split('_').map(&:camelize).join
  end
end

loader = Zeitwerk::Loader.new
loader.push_dir('lib')
loader.inflector = CustomInflector.new
Application::INFLECTIONS.each { |k, v| loader.inflector.inflect(k => v) }
loader.enable_reloading unless Application.groups.include? 'production'
loader.setup

Application.loader = loader
