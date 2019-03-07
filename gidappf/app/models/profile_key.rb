class ProfileKey < ApplicationRecord
  ##########################################################################
  # Asociación uno a muchos: soporta que un ProfileKey sea asignado muchas #
  #                          veces en una relación profile                 #
  ##########################################################################
  belongs_to :profile, optional: true

  ##########################account#########################################
  # Asociación uno a uno: soporta que un ProfileKey sea asignado a un      #
  #                   profile_values.Si se borra, lo hace profile_values.  #
  # ##########################################################################
  # has_one :profile_value, dependent: :destroy
  # accepts_nested_attributes_for :profile_value

  ##########################account#########################################
  # Asociación uno a muchos: soporta que un ProfileKey sea asignado muchas #
  #                          veces en distintos profile_values.            #
  #                          Si se borra, lo hacen profile_values.         #
  ##########################################################################
  has_many :profile_values, dependent: :destroy
  accepts_nested_attributes_for :profile_values

end
