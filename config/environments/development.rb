Rails.application.configure do
  config.cache_classes = false
  config.eager_load = false
  config.consider_all_requests_local = true
  if Rails.root.join("tmp/caching-dev.txt").exist?
    config.action_controller.perform_caching = true
    config.cache_store = :memory_store
    config.public_file_server.headers = {
      "Cache-Control" => "public, max-age=#{2.days.seconds.to_i}",
    }
  else
    config.action_controller.perform_caching = false
    config.cache_store = :null_store
  end
  config.action_mailer.raise_delivery_errors = false
  config.action_mailer.perform_caching = false
  config.active_support.deprecation = :log
  config.active_record.migration_error = :page_load
  config.assets.debug = true
  config.assets.quiet = true
  config.file_watcher = ActiveSupport::EventedFileUpdateChecker
  config.action_mailer.default_url_options = { :host => "sem-barranquilla.herokuapp.com" }
  config.cache_store = :redis_store, (ENV["REDIS_URL"] || "redis://h:pab1d46f89ee750fa73be608306865756164e225d4f76eb1dbfa525ab49e162dd@ec2-3-224-53-9.compute-1.amazonaws.com:14329"), { expires_in: 5.minutes }
end
