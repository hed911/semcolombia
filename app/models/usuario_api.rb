class UsuarioApi < ApplicationRecord
  has_secure_password
  validates :username, presence: true, uniqueness: true
  validates :password,
            length: { minimum: 6 },
            if: -> { new_record? || !password.nil? }

  belongs_to :departamento, optional:true
  belongs_to :municipio, optional:true
end
# UsuarioApi.create! nombre:"prueba 01", username:"test", password:"12345678"

# ASI SE CREA UN USUARIO API
#token = Digest::SHA1.hexdigest([Time.now, rand].join).upcase
#UsuarioApi.create! nombre: "prueba 02", username: token, password:token
