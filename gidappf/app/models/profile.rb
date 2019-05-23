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
  has_many :documents, dependent: :destroy

  ##########################account#####################################
  # Asociación uno a muchos: soporta que un perfil sea asignado muchas #
  #                          veces en distintos profile_keys.          #
  #                          Si se borra, lo hacen profile_keys.       #
  ######################################################################
  has_many :profile_keys, dependent: :destroy

  ##########################account#####################################
  # Configuracion dependencia de atributos:                            #
  #        Los atributos de Profile dependen de profile_keys.          #
  ######################################################################
  accepts_nested_attributes_for :profile_keys
  validate :check_date_interval
  # validate :check_nested_params
  #

  ########################################################################################
  # Prerequisitos:                                                                       #
  #           1) Modelo de datos inicializado.                                           #
  #           2) Asociacion un User a muchos Documents registrada en el modelo.          #
  #           3) Asociacion un Profile a muchos Documents registrada en el modelo.       #
  #           4) Asociacion un Profile a muchos ProfileKey registrada en el modelo.      #
  #           5) Asociacion un ProfileKey a muchos ProfileValue registrada en el modelo. #
  #           6) Existencia de la plantilla del perfil en Profile.firts.                 #
  # Devolución: Las claves (ProfileKey) de la plantilla perfil se copian en este perfil. #
  ########################################################################################
  def copy_template(template,key3)
    index=User.find_by(email: template).documents.first.profile.profile_keys.first.id.to_i
    if self.profile_keys.empty? then #copia claves del perfil si no tiene
      User.find_by(email: template).documents.first.profile.profile_keys.each do |i|
        unless i.key.eql?(User.find_by(email: template).documents.first.profile.profile_keys.find(index+2).key) then
          self.profile_keys.build(:key => i.key, :client_side_validator_id => i.client_side_validator_id).profile_values.build(:value => nil).save
        else #copia el valor del dni si es la clave 3 de la plantilla
          self.profile_keys.build(:key => i.key, :client_side_validator_id => i.client_side_validator_id).profile_values.build(:value => key3).save
        end
      end
    end
  end

  private
  #######################################################################
  # Usado en la validacion.                                             #
  #######################################################################
  def check_date_interval
    errors.add(:valid_to, 'must be a valid datetime') unless Date.parse(valid_to.to_s) > Date.parse(valid_from.to_s)
  end
end
