class TimeSheet < ApplicationRecord
  belongs_to :commission

  #########################################################################
  # Asociación uno a muchos: soporta que un periodo sea asignada muchas   #
  #                          veces en la relación time_sheet_hour.        #                                                       #
  #                          Si se borra, lo hacen los  time_sheet_hour.  #
  #########################################################################
  has_many :time_sheet_hours, dependent: :delete_all
  validate :check_date_interval

  #####################################################################
  # Prerequisitos:                                                    #
  #           1) Modelo de datos inicializado.                        #
  # parámetros:                                                       #
  #           ninguno.                                                #
  # Devolución: texto con el identificador de la comision asociada al #
  #             periodo.                                              #
  #####################################################################
  def to_list
    self.commission.name
  end

  ########################################################################
  # Prerequisitos:                                                       #
  #           1) Modelo de datos inicializado.                           #
  # parámetros:                                                          #
  #           ninguno.                                                   #
  # Devolución: Array con dos elementos, el primero es el minimo horario #
  #          TimeSheetHour de los asignados. El segundo es el maximo     #
  #          horario de los asignados.                                   #
  ########################################################################
  def time_category
    out=[]
    unless self.time_sheet_hours.empty?
      min=60*24
      max=0
      self.time_sheet_hours.each do |h|
        if h.from_min.to_i+h.from_hour.to_i*60 < min then min=h.from_min.to_i+h.from_hour.to_i*60 end
        if h.to_min.to_i+h.to_hour.to_i*60 > max then max=h.to_min.to_i+h.to_hour.to_i*60 end
      end
      out << min
      out << max
    end
    out
  end

  ############################################################################
  # Prerequisitos:                                                           #
  #           1) Modelo de datos inicializado.                               #
  # parámetros:                                                              #
  #           trayect. (Primero, Segundo, Tercero, etc.)                     #
  # Devolución: True si las materias asignadas a los TimeSheetHour asignados #
  #           al presente TimeSheet tienen un trayect igual a trayect.       #
  ############################################################################
  def is_of_trayect?(trayect)
    true
  end

  private

  #######################################################################
  # Usado en la validacion.                                             #
  #######################################################################
  def check_date_interval
    errors.add(:end_date, 'must be a valid datetime') unless Date.parse(end_date.to_s) > Date.parse(start_date.to_s)
  end
end
