# frozen_string_literal: true

Sentry.init do |config|
  config.dsn = ENV['SENTRY_DSN']

  config.breadcrumbs_logger = [:active_support_logger]
  config.enabled_environments = %w[production staging]
  config.environment = ENV['SENTRY_ENV'] || Rails.env
  config.traces_sample_rate = 0.5

  filter = ActiveSupport::ParameterFilter.new(Rails.application.config.filter_parameters)
  config.before_send = lambda { |event, _hint| filter.filter(event.to_hash) }
end
