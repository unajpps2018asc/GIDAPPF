class ClassRoomInstitute < ApplicationRecord
  #####################################################################
  # Asociación uno a muchos: soporta que un Aula sea asignada muchas  #
  #                          veces en la relación vacancy             #                                                       #
  #####################################################################
  has_many :vacancy
end
