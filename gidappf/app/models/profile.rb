require 'gidappf_templates_tools'
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

  #########################################################################################
  # Método privado: implementa inicialización de la variable estática @@template.         #
  # Prerequisitos:                                                                        #
  #           1) Modelo de datos inicializado.                                            #
  #           2) Asociacion un Profile a muchos ProfileKey registrada en el modelo.       #
  #           3) Asociacion un ProfileKey a muchos ProfileValue registrada en el modelo.  #
  #           4) Existencia del arreglo estático LockEmail::LIST.                         #
  # Devolución: Rol para asociarlo al nuevo perfil.                                       #
  #########################################################################################
    def template_to_merge
      out=''
      profile=self.profile_keys.pluck(:key)
      if GidappfTemplatesTools.compare_templates_do(profile, User.find_by(email:LockEmail::LIST[4]).documents.first.profile.profile_keys.pluck(:key)) then
        out = LockEmail::LIST[4];
      elsif GidappfTemplatesTools.compare_templates_do(profile, User.find_by(email:LockEmail::LIST[3]).documents.first.profile.profile_keys.pluck(:key)) then
        out = LockEmail::LIST[3];
      end
      out
    end

  #########################################################################################
  # Método privado: implementa merge para profile_value de cada profile_key.              #
  # Prerequisitos:                                                                        #
  #           1) Modelo de datos inicializado.                                            #
  #           2) Asociacion un Profile a muchos ProfileKey registrada en el modelo.       #
  #           3) Asociacion un ProfileKey a muchos ProfileValue registrada en el modelo.  #
  # Devolución: mantiene un único profile_value actualizado por cada profile_key.         #
  #########################################################################################
    def merge_each_value
      self.profile_keys.each do |k|
        if k.profile_values.count == 2 then
          max=self.profile_keys.find(k.id).profile_values.find_by(created_at: k.profile_values.maximum('created_at'))
          min=self.profile_keys.find(k.id).profile_values.find_by(created_at: k.profile_values.minimum('created_at'))
          if max.value.empty? && !min.value.empty? then max.update(value: min.value) end
          min.destroy
        end
      end
    end

  #########################################################################################
  # Método privado: implementa merge para profile_key del @profile seleccionado.          #
  # Prerequisitos:                                                                        #
  #           1) Modelo de datos inicializado.                                            #
  #           2) Asociacion un Profile a muchos ProfileKey registrada en el modelo.       #
  #           3) Asociacion un ProfileKey a muchos ProfileValue registrada en el modelo.  #
  #           4) Existencia del arreglo estático LockEmail::LIST.                         #
  #           5) Existencia de la variable de clase @@template inicializada.              #
  # Devolución: mantiene los elementos de profile_keys equivalente al de @@templale.      #
  #########################################################################################
    def merge_each_key(template)
      User.find_by(email: template).documents.first.profile.profile_keys.each do |tpk|
        if self.profile_keys.where(key: tpk.key).count == 2 then
          keys=self.profile_keys.where(key: tpk.key)
          max=keys.find_by(key: tpk.key,created_at: keys.maximum('created_at'))
          min=keys.find_by(key: tpk.key,created_at: keys.minimum('created_at'))
          read_only_or_link=ClientSideValidator.where(content_type: "GIDAPPF links").
            or(ClientSideValidator.where(content_type: "GIDAPPF read only")).include?(min.client_side_validator)
          if max.client_side_validator_id.nil? && !read_only_or_link then
            max.update(client_side_validator_id: tpk.client_side_validator_id)
            min.destroy
          elsif read_only_or_link then
            max.destroy
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
