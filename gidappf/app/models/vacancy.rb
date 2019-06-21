class Vacancy < ApplicationRecord
  ########################################################################
  # Asociación muchos a uno:soporta muchos Vacancies pertenecientes      #
  #                         a un ClassRoomInstitute                      #
  ########################################################################
  belongs_to :class_room_institute

  #####################################################################
  # Asociación uno a muchos: soporta que un Aula sea asignada muchas  #
  #                          veces en la relación vacancy             #
  #####################################################################
  has_many :time_sheet_hours, dependent: :delete_all
end
