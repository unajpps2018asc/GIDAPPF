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
# Archivo GIDAPPF/gidappf/app/models/usercommissionrole.rb                #
###########################################################################
class Usercommissionrole < ApplicationRecord

  #############################################################################
  # Asociación muchos a uno:soporta muchos usercommissionroles pertenecientes #
  #                         a un rol                                          #
  #############################################################################
  belongs_to :role

  #############################################################################
  # Asociación muchos a uno:soporta muchos usercommissionroles pertenecientes #
  #                         a un usuario                                      #
  #############################################################################
  belongs_to :user

  #############################################################################
  # Asociación muchos a uno:soporta muchos usercommissionroles pertenecientes #
  #                         a una comisión                                    #
  #############################################################################
  belongs_to :commission
end
