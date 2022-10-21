def render(context:, view_file:, instance: Object.new, payload: {})
  Tilt.new("#{context}/#{view_file}").render(instance, payload)
end
