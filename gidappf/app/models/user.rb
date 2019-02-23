##########################################################################
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
  DEFAULTPASS = "1234gidappf"

  #############################################################################
  # Configuracion del control de autenticacion Devise                         #
  #############################################################################
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,:recoverable, :rememberable, :validatable, :jwt_authenticatable, jwt_revocation_strategy: Devise::JWT::RevocationStrategies::Null

  #############################################################################
  # Asociación uno a muchos: soporta que un usuario sea asignado muchas veces #
  #                          en la commision como el creador de la comision   #
  #############################################################################
  has_many :commission

  ##########################account######################################
  # Asociación uno a muchos: soporta que un usuario sea asignada muchas #
  #                          veces en la relación usercommissionrole    #
  #######################################################################
  has_many :usercommissionrole

  validate :minimun_security_requierements

  ##########################account######################################
  # Usado en la validacion.                                             #
  #######################################################################
  def minimun_security_requierements
    errors.add(:password,'Is a default, please use another password...') unless is_usable_password?
  end

  #######################################################################################
  # Prerequisitos: 1) Modelo inicializado.                                              #
  #               2) Policy con la implementacion adecuada a las acciones desarrolladas.#
  # Devolución: True si el password ingresado es aceptable.                             #
  #######################################################################################
  def is_usable_password?
    !DEFAULTPASS.eql?(password)
  end

end
