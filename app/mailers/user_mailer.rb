require 'digest/sha2'
class UserMailer < ActionMailer::Base
  default :from => 'sandbox4910b51e313042908486a3f34376c5da.mailgun.org', 'Message-ID' => "#{Digest::SHA2.hexdigest(Time.now.to_i.to_s)}@sem.com"

  def create_user_instructions(nombre, email, password, roles)
    @name = nombre
    @email = email
    @password = password
    @roles = roles
    mail(to: [email], subject: "#{nombre} bienvenido a la plataforma")
  end

end
