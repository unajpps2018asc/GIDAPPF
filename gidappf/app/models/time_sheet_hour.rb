require 'mins_day_tools'
class TimeSheetHour < ApplicationRecord
  include MinsDayTools
  #############################################################################
  # Asociación muchos a uno:soporta muchos TimeSheetHours pertenecientes      #
  #                         a una Vacancy                                     #
  #############################################################################
  belongs_to :vacancy

  #############################################################################
  # Asociación muchos a uno:soporta muchos TimeSheetHours pertenecientes      #
  #                         a una Vacancy                                     #
  #############################################################################
  belongs_to :time_sheet

  #############################################################################
  # Asociación uno a uno:soporta muchos TimeSheetHours pertenecientes         #
  #                         a una Matter                                      #
  #############################################################################
  belongs_to :matter

  validates :from_hour, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than: 24}
  validates :to_hour, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than: 24}
  validates :from_min, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than: 60}
  validates :to_min, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than: 60}
  validates :to_hour, numericality: { greater_than_or_equal_to: :from_hour}
  # validate :check_time_interval

  ########################################################################
  # Prerequisitos:                                                       #
  #           1) Modelo de datos inicializado.                           #
  # parámetros:                                                          #
  #           ninguno.                                                   #
  # Devolución: texto con el intervalo del horario.                      #
  ########################################################################
  def occupied_hour_fmt
    mins_to_hours_interval_str(self.to_hour*60+self.to_min,self.from_hour*60+self.from_min)
  end#occupied_hour_fmt

  #################################################################################
  # Usado en ClassRoomInstitute.hole_from_to                                      #
  #################################################################################
  def hour_week
    week=Array.new
    week << self.monday
    week << self.tuesday
    week << self.wednesday
    week << self.thursday
    week << self.friday
    week << self.saturday
    week << self.sunday
    week
  end
  private

  #######################################################################
  # Usado en la validacion.                                             #
  #######################################################################
  # def check_time_interval
  #   errors.add(:to_hour, 'must be a valid time') unless Date.parse(end_date.to_s) > Date.parse(start_date.to_s)
  # end

end
