if Application.groups.include? :development
  Dotenv.load('.env', '.secrets')
end
