##########################################################################
# Universidad Nacional Arturo Jauretche                                   #
# Instituto de Ingeniería y Agronomía -Ingeniería en Informática          #
# Práctica Profesional Supervisada Nro 12 - Segundo cuatrimestre de 2018  #
#       <<Gestión Integral de Alumnos Para el Proyecto Fines>>            #
# Tutores:                                                                #
#       - UNAJ: Dr. Ing. Morales, Martín                                  #
#       - INSTITUCION: Ing. Cortes Bracho, Oscar                          #
#       - TAPTA: Dra. Ferrari, Mariela                                    #
# Autor: Ap. Daniel Rosatto <danielrosatto@gmail.com>                     #
###########################################################################

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,:recoverable, :rememberable, :validatable, :jwt_authenticatable, jwt_revocation_strategy: Devise::JWT::RevocationStrategies::Null

end
