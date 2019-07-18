require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Gidappf
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set up logging to be the same in all environments but control the level
    # through an environment variable.
    config.log_level = ENV['LOG_LEVEL']

    # Log to STDOUT because Docker expects all processes to log here. You could
    # then redirect logs to a third party service on your own such as systemd,
    # or a third party host such as Loggly, etc..
    logger           = ActiveSupport::Logger.new(STDOUT)
    logger.formatter = config.log_formatter
    config.log_tags  = %i[subdomain uuid]
    config.logger    = ActiveSupport::TaggedLogging.new(logger)

    # Action mailer settings.
    config.action_mailer.delivery_method = :smtp
    config.action_mailer.smtp_settings = {
      address:              ENV['SMTP_ADDRESS'],
      port:                 ENV['SMTP_PORT'].to_i,
      domain:               ENV['SMTP_DOMAIN'],
      user_name:            ENV['SMTP_USERNAME'],
      password:             ENV['SMTP_PASSWORD'],
      authentication:       ENV['SMTP_AUTH'],
      enable_starttls_auto: ENV['SMTP_ENABLE_STARTTLS_AUTO'] == 'true'
    }

    config.action_mailer.default_url_options = {
      host: ENV['ACTION_MAILER_HOST']
    }
    config.action_mailer.default_options = {
      from: ENV['ACTION_MAILER_DEFAULT_FROM']
    }

    # Set Redis as the back-end for the cache.
    config.cache_store = :redis_cache_store, {
      url: ENV['REDIS_CACHE_URL'],
      namespace: ENV['REDIS_CACHE_NAMESPACE']
    }

    # Set Sidekiq as the back-end for Active Job.
    config.active_job.queue_adapter = :sidekiq
    config.active_job.queue_name_prefix =
      "#{ENV['ACTIVE_JOB_QUEUE_PREFIX']}_#{Rails.env}"

    # Action Cable setting to de-couple it from the main Rails process.
    config.action_cable.url = ENV['ACTION_CABLE_FRONTEND_URL']

    # Action Cable setting to allow connections from these domains.
    origins = ENV['ACTION_CABLE_ALLOWED_REQUEST_ORIGINS'].split(',')
    origins.map! { |url| /#{url}/ }
    config.action_cable.allowed_request_origins = origins
    ###########################################################################
    # Cargador de módulos en lib                                              #
    ###########################################################################
    config.autoload_paths << "#{Rails.root}/lib"
    config.eager_load_paths << "#{Rails.root}/lib"

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.i18n.available_locales = [:en, :es]
    config.i18n.default_locale = :en
  end
end

# Show in-line form errors.
ActionView::Base.field_error_proc = proc do |html_tag, instance|
  if /\<label/.match?(html_tag)
    html_tag
  else
    errors = Array(instance.error_message).join(',')
    %(#{html_tag}<p class="validation-error"> #{errors}</p>).html_safe
  end
end
