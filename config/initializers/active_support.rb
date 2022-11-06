ActiveSupport::Inflector.inflections(:en) do |inflect|
  Application::INFLECTIONS.each { |_k, v| inflect.acronym v }
end
