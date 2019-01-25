class TimeSheet < ApplicationRecord
  belongs_to :commission

  #########################################################################
  # Asociación uno a muchos: soporta que un periodo sea asignada muchas   #
  #                          veces en la relación time_sheet_hour         #                                                       #
  #########################################################################
  has_many :time_sheet_hour, dependent: :delete_all
end
