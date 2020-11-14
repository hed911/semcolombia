Rails.application.configure do
  config.cache_classes = true
  config.eager_load = true
  config.consider_all_requests_local = false
  config.action_controller.perform_caching = true
  config.read_encrypted_secrets = true
  config.public_file_server.enabled = true
  config.assets.js_compressor = Uglifier.new(harmony: true)
  config.assets.compile = false
  config.log_level = :debug
  config.log_tags = [:request_id]
  config.action_mailer.perform_caching = false
  config.i18n.fallbacks = true
  config.active_support.deprecation = :notify
  config.log_formatter = ::Logger::Formatter.new
  if ENV["RAILS_LOG_TO_STDOUT"].present?
    logger = ActiveSupport::Logger.new(STDOUT)
    logger.formatter = config.log_formatter
    config.logger = ActiveSupport::TaggedLogging.new(logger)
  end
  config.active_record.dump_schema_after_migration = false
  config.action_mailer.default_url_options = { :host => "sem-barranquilla.herokuapp.com" }
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.perform_deliveries = true
  config.cache_store = :redis_store, (ENV["REDIS_URL"] || "redis://h:pab1d46f89ee750fa73be608306865756164e225d4f76eb1dbfa525ab49e162dd@ec2-3-224-53-9.compute-1.amazonaws.com:14329"), { expires_in: 5.minutes }
  config.force_ssl = true
end