class TimeSheet < ApplicationRecord
  belongs_to :commission

  #########################################################################
  # Asociación uno a muchos: soporta que un periodo sea asignada muchas   #
  #                          veces en la relación time_sheet_hour         #                                                       #
  #########################################################################
  has_many :time_sheet_hour, dependent: :delete_all
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

  private

  #######################################################################
  # Usado en la validacion.                                             #
  #######################################################################
  def check_date_interval
    errors.add(:end_date, 'must be a valid datetime') unless Date.parse(end_date.to_s) > Date.parse(start_date.to_s)
  end
end
