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
  validate :check_date_interval
  # validate :check_nested_params
  #
  private
  #######################################################################
  # Usado en la validacion.                                             #
  #######################################################################
  def check_date_interval
    errors.add(:valid_to, 'must be a valid datetime') unless Date.parse(valid_to.to_s) > Date.parse(valid_from.to_s)
  end
  #
  # #######################################################################
  # # Usado en la validacion.                                             #
  # #######################################################################
  # def check_nested_params
  #   errors.add(:name, "must be a valid nested atribute: #{detect_fail}") unless nested_validations_ok
  # end
  #
  # def nested_validations_ok
  #   out=true
  #   unless self.profile_keys.nil?
  #     self.profile_keys.each_with_index do |key, index|
  #       if index == 4 then out = (!Date.parse(key.profile_values.first.value).present? rescue false;) end
  #     end
  #   end
  #   out
  # end
  #
  # def detect_fail
  #   self.profile_keys.each_with_index do |key, index|
  #     if index == 3 && (!Date.parse(key.profile_values.first.value).present? rescue true;) then
  #       out << key.key
  #     end
  #   end
  # end
end
