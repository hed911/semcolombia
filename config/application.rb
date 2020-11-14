require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module SemColombiaV2
  class Application < Rails::Application
    config.load_defaults 5.1
    config.autoload_paths = %W[#{config.root}/lib]
    config.autoload_paths += Dir[Rails.root.join('app', 'models', '{*/}')]
    config.assets.paths << Rails.root.join('app', 'assets', 'fonts')
    config.encoding = 'utf-8'
    config.time_zone = 'America/Bogota'
    config.active_record.default_timezone = :utc
    config.assets.precompile += %w[*.js *.css]
    #config.active_job.queue_adapter = :resque
    config.i18n.default_locale = :es
    config.active_job.queue_adapter = :resque
  end
end

Raven.configure do |config|
  config.dsn = 'https://9201821804904c5091d7aee8b5926fc9:fc4ce07675964942b9b34ee89ba8c92f@o246988.ingest.sentry.io/5192814'
end
