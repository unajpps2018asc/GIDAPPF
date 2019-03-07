###########################################################################
# Universidad Nacional Arturo Jauretche                                   #
# Instituto de Ingeniería y Agronomía -Ingeniería en Informática          #
# Práctica Profesional Supervisada Nro 12 - Segundo cuatrimestre de 2018  #
#    <<Gestión Integral de Alumnos Para el Proyecto Fines>>               #
# Tutores:                                                                #
#    - UNAJ: Dr. Ing. Morales, Martín                                     #
#    - ORGANIZACIÓN: Ing. Cortes Bracho, Oscar                            #
#    - ORGANIZACIÓN: Mg. Ing. Diego Encinas                               #
#    - TAPTA: Dra. Ferrari, Mariela                                       #
# Autor: Ap. Daniel Rosatto <danielrosatto@gmail.com>                     #
# Archivo GIDAPPF/gidappf/app/models/user.rb                              #
###########################################################################
# t.string "email", default: "", null: false
# t.string "encrypted_password", default: "", null: false
# t.string "reset_password_token"
# t.datetime "reset_password_sent_at"
# t.datetime "remember_created_at"
# t.datetime "created_at", null: false
# t.datetime "updated_at", null: false
###########################################################################
class User < ApplicationRecord

  #############################################################################
  # Configuracion del control de autenticacion Devise                         #
  #############################################################################
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,:recoverable, :rememberable, :validatable, :jwt_authenticatable, jwt_revocation_strategy: Devise::JWT::RevocationStrategies::Null

  #############################################################################
  # Asociación uno a muchos: soporta que un usuario sea asignado muchas veces #
  #                          en la commision como el creador de la comision.  #
  #                          Si se borra, la comision nilifica al creador.    #
  #############################################################################
  has_many :commissions, dependent: :nullify

  ##########################account######################################
  # Asociación uno a muchos: soporta que un usuario sea asignada muchas #
  #                          veces en la relación usercommissionrole.   #
  #                          Si se borra, lo hace  usercommissionrole.  #
  #######################################################################
  has_many :usercommissionroles, dependent: :delete_all

  ##########################account######################################
  # Asociación uno a muchos: soporta que un usuario sea asignada muchas #
  #                          veces en la relación document.             #
  #                          Si se borra, el document nilifica user.    #
  #######################################################################
  has_many :documents, dependent: :nullify

  validate :minimun_security_requierements

  ##########################account######################################
  # Usado en la validacion.                                             #
  #######################################################################
  def minimun_security_requierements
    errors.add(:password,'Is a default, please use another password...') unless is_usable_password?
  end

  ####################################################################################
  # Prerequisitos:                                                                   #
  #     1) Modelo inicializado.                                                      #
  #     2) Usuario con email student@gidappf.edu.ar existente.                       #
  #     3) Clase LockEmail existente conteniendo el array LIST.                      #
  #     4) Perfil de usuario con email student@gidappf.edu.ar existente en LIST[1]). #
  #     5) Clave 3 del perfil de usuario student@gidappf.edu.ar existente.           #
  # Devolución: True si el password ingresado es aceptable.                          #
  ####################################################################################
  def is_usable_password?
    out = true
    unless LockEmail::LIST.include?(self.email) then
      dni = User.find_by(email: LockEmail::LIST[1]).documents.first.profile.profile_keys.find(3).key
      if self.documents.present? &&
        self.documents.first.profile.profile_keys.find_by(key: dni).profile_values.present? then
        if self.documents.first.profile.profile_keys.find_by(key: dni).
          profile_values.first.value.eql?(password) then
          out = false
        end
      end
    end
    out
  end

end
