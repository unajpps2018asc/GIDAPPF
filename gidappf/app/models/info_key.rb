class InfoKey < ApplicationRecord
  #############################################################################
  # Asociación muchos a uno: Soporta muchos InfoKey pertenecientes a una      #
  #     Information, opcional para que funcione accepts_nested_attributes_for.#
  #############################################################################
  belongs_to :input, optional: true

  ##########################account#########################################
  # Asociación uno a muchos: soporta que un InfoKey sea asignado muchas    #
  #                          veces en distintos info_values.               #
  #                          Si se borra, se anulan en info_values.        #
  ##########################################################################
  has_many :info_values, dependent: :destroy

  ##########################account#########################################
  # Configuracion dependencia de atributos:                                #
  #        Los atributos de InfoKey dependen de info_values.               #
  ##########################################################################
  belongs_to :client_side_validator, optional: true
  accepts_nested_attributes_for :info_values
end
