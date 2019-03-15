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
# Archivo GIDAPPF/gidappf/app/models/profile_key.rb                       #
###########################################################################
class ProfileKey < ApplicationRecord
  #############################################################################
  # Asociación muchos a uno: Soporta muchos ProfileKey pertenecientes a un    #
  #         Profile, opcional para que funcione accepts_nested_attributes_for.#
  #############################################################################
  belongs_to :profile, optional: true

  ##########################account#########################################
  # Asociación uno a muchos: soporta que un ProfileKey sea asignado muchas #
  #                          veces en distintos profile_values.            #
  #                          Si se borra, lo hacen profile_values.         #
  ##########################################################################
  has_many :profile_values, dependent: :delete_all

  ##########################account#########################################
  # Configuracion dependencia de atributos:                                #
  #        Los atributos de ProfileKey dependen de profile_values.         #
  ##########################################################################
  belongs_to :client_side_validator, optional: true
  accepts_nested_attributes_for :profile_values

end
