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

class User < ApplicationRecord

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

  ###########################################################################
  # Asociación uno a muchos: soporta que un usuario sea asignada muchas     #
  #                          veces en la relación usercommissionrole        #                                                       #
  ###########################################################################
  has_many :usercommissionrole
end
