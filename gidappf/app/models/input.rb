class Input < ApplicationRecord
  ##########################account#####################################
  # Asociación uno a muchos: soporta que un input sea asignado muchas  #
  #                          veces en distintos documents.             #
  #                          Si se borra, lo hacen documents.          #
  ######################################################################
  has_many :documents, dependent: :destroy

  ##########################account#####################################
  # Asociación uno a muchos: soporta que un input sea asignado muchas  #
  #                          veces en distintos info_keys.             #
  #                          Si se borra, anula info_keys.             #
  ######################################################################
  has_many :info_keys, dependent: :nullify

  ##########################account#####################################
  # Configuracion dependencia de atributos:                            #
  #        Los atributos de Input dependen de Info_keys.               #
  ######################################################################
  accepts_nested_attributes_for :info_keys

  ###################################################################################
  # Prerequisitos:                                                                  #
  #           1) Modelo de datos inicializado.                                      #
  #           2) Asociacion un User a muchos Documents registrada en el modelo.     #
  #           3) Asociacion un Input a muchos Documents registrada en el modelo.    #
  #           4) Asociacion un Input a muchos InfoKey registrada en el modelo.      #
  #           5) Asociacion un InfoKey a muchos InfoValue registrada en el modelo.  #
  #           6) Existencia de la plantilla del perfil en Input.find(template).     #
  # Devolución: Las claves (InfoKey) de la plantilla input se copian en este Input. #
  ###################################################################################
  def copy_template(template)
    if self.info_keys.empty? then #copia claves si no tiene
      Input.find(template).info_keys.each do |i|
        self.info_keys.build(:key => i.key, :client_side_validator_id => i.client_side_validator_id).info_values.build(:value => nil).save
      end
    end
  end
end
