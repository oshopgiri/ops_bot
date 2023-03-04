# frozen_string_literal: true

ActiveSupport::Inflector.inflections do |inflect|
  Application::INFLECTIONS.each { |_k, v| inflect.acronym v }
end
