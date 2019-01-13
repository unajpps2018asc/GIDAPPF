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
# Archivo GIDAPPF/gidappf/app/models/commission.rb                        #
###########################################################################
class Commission < ApplicationRecord

  ###########################################################################
  # Asociación muchos a uno:soporta muchas comisiones pertenecientes a un   #
  #                         usuario                                         #
  ###########################################################################
  belongs_to :user

  ###########################################################################
  # Asociación uno a muchos: soporta que una comision sea asignada muchas   #
  #                          veces en la relación usercommissionrole        #                                                       #
  ###########################################################################
  has_many :usercommissionrole

  ###########################################################################
  # Asociación uno a muchos: soporta que una comision sea asignada muchas   #
  #                          veces en la relación vacancy                   #                                                       #
  ###########################################################################
  has_many :vacancy
end
