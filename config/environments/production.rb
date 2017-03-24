# frozen_string_literal: true

# This is a dummy configuration, which stays as close as possible to the
# actual one used in production while remaining runnable on local setups
# without additional dependencies (nginx).

Rails.application.configure do
  config.cache_classes = true
  config.eager_load = true

  config.consider_all_requests_local = false

  config.action_controller.perform_caching = true
  config.cache_store = :memory_store

  config.action_mailer.raise_delivery_errors = false
  config.action_mailer.perform_caching = false

  config.active_support.deprecation = :notify

  config.active_record.migration_error = :page_load
end
