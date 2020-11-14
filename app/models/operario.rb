class Operario < ActiveRecord::Base
  self.table_name = 'operarios'
  devise :database_authenticatable,
         :rememberable,
         :trackable,
         :validatable


  #attr_accessible :updated_position_at, :email, :cedula, :nombre,
  #                :password, :encrypted_password, :reset_password_token, :reset_password_sent_at,
  #                :remember_created_at, :sign_in_count, :last_sign_in_at, :current_sign_in_ip,
  #                :last_sign_in_ip
  has_many :devices
  has_many :ubicacions
  has_many :caso_deportivos

  def updated_position_at_formatted
    updated_position_at.strftime('%m/%e/%Y %l:%M %p') if updated_position_at
  end
end
