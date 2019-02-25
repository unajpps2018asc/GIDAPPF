class ProfileKey < ApplicationRecord
  ##########################################################################
  # Asociación uno a muchos: soporta que un ProfileKey sea asignado muchas #
  #                          veces en una relación profile                 #
  ##########################################################################
  belongs_to :profile
  ##########################account#########################################
  # Asociación uno a muchos: soporta que un ProfileKey sea asignado muchas #
  #                          veces en distintos profile_values.            #
  #                          Si se borra, lo hacen profile_values.         #
  ##########################################################################
  has_many :profile_value, dependent: :delete_all
end
