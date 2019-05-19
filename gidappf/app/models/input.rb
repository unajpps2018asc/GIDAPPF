class Input < ApplicationRecord
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
  has_many :info_keys, dependent: :nullify

  ##########################account#####################################
  # Configuracion dependencia de atributos:                            #
  #        Los atributos de Profile dependen de profile_keys.          #
  ######################################################################
  accepts_nested_attributes_for :info_keys
end
