loader = Zeitwerk::Loader.new
loader.push_dir('lib')
Application::INFLECTIONS.each { |k, v| loader.inflector.inflect(k => v) }
loader.setup
