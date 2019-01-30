###########################################################################
# Universidad Nacional Arturo Jauretche                                   #
# Instituto de Ingeniería y Agronomía -Ingeniería en Informática          #
# Práctica Profesional Supervisada Nro 12 - Segundo cuatrimestre de 2018  #
#    <<Gestión Integral de Alumnos Para el Proyecto Fines>>               #
# Tutores:                                                                #
#    - UNAJ: Dr. Ing. Morales, Martín                                     #
#    - ORGANIZACIÓN: Ing. Cortes Bracho, Oscar                            #
#    - ORGANIZACIÓN: Mg. Ing. Diego Encinas                               #
#    - TAPTA: Dra. Ferrari, Mariela                                       #
# Autor: Ap. Daniel Rosatto <danielrosatto@gmail.com>                     #
# Archivo GIDAPPF/gidappf/app/models/commission.rb                        #
###########################################################################
class Commission < ApplicationRecord

  ###########################################################################
  # Asociación muchos a uno:soporta muchas comisiones pertenecientes a un   #
  #                         usuario                                         #
  ###########################################################################
  belongs_to :user

  ###########################################################################
  # Asociación uno a muchos: soporta que una comision sea asignada muchas   #
  #                          veces en la relación usercommissionrole        #                                                       #
  ###########################################################################
  has_many :usercommissionrole, dependent: :delete_all

  ###########################################################################
  # Asociación uno a muchos: soporta que una comision sea asignada muchas   #
  #                          veces en la relación time_sheet                   #                                                       #
  ###########################################################################
  has_many :time_sheet, dependent: :delete_all

  validate :check_date_interval

  private

  def check_date_interval
    errors.add(:end_date, 'must be a valid datetime') unless Date.parse(end_date.to_s) > Date.parse(start_date.to_s)
  end
end
