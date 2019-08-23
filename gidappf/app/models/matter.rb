class Matter < ApplicationRecord
  #######################################################################
  # Asociación uno a muchos: soporta que una Matter sea asignada muchas #
  #            veces en la relación TimeSheetHour, una por cada vacante #
  #######################################################################
  has_many :time_sheet_hours, dependent: :delete_all
end
