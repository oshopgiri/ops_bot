# frozen_string_literal: true

OpsBot::Context.build

Application.exception_notifier = OpsBot::Integration::Sentry.instance
