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
# Archivo GIDAPPF/gidappf/app/models/profile_value.rb                     #
###########################################################################
class ProfileValue < ApplicationRecord
  #############################################################################
  # Asociación muchos a uno: Soporta muchos ProfileValue pertenecientes a un  #
  #      ProfileKey, opcional para que funcione accepts_nested_attributes_for.#
  #############################################################################
  belongs_to :profile_key, optional: true
  has_one_attached :active_stored

  def gidappf_readonly?
    self.profile_key.profile_values.count > 0 &&
    self.profile_key.client_side_validator_id.present? &&
    self.profile_key.client_side_validator.content_type.eql?('GIDAPPF read only')
  end
end
