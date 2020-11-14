ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.perform_deliveries = true
ActionMailer::Base.raise_delivery_errors = true
ActionMailer::Base.smtp_settings = {
  port: '587',
  address: 'smtp.sendgrid.net',
  user_name: ENV['SENDGRID_USERNAME'],
  password: ENV['SENDGRID_PASSWORD'],
  domain: DOMINIO_PROYECTO_CRUE_V2,
  authentication: :plain,
  enable_starttls_auto: true
}
