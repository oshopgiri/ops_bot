# frozen_string_literal: true

Dotenv.load('.env', '.secrets') if Application.groups.include? :development
