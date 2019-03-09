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
# Archivo GIDAPPF/gidappf/app/models/profile.rb                           #
###########################################################################
class Profile < ApplicationRecord
  ##########################account#####################################
  # Asociación uno a muchos: soporta que un perfil sea asignado muchas #
  #                          veces en distintos documents.             #
  #                          Si se borra, lo hacen documents.          #
  ######################################################################
  has_many :documents, dependent: :delete_all

  ##########################account#####################################
  # Asociación uno a muchos: soporta que un perfil sea asignado muchas #
  #                          veces en distintos profile_keys.          #
  #                          Si se borra, lo hacen profile_keys.       #
  ######################################################################
  has_many :profile_keys, dependent: :delete_all

  ##########################account#####################################
  # Configuracion dependencia de atributos:                            #
  #        Los atributos de Profile dependen de profile_keys.          #
  ######################################################################
  accepts_nested_attributes_for :profile_keys
end
