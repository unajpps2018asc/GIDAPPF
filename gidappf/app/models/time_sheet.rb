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
# Archivo GIDAPPF/gidappf/app/models/time_sheet.rb                        #
###########################################################################
class TimeSheet < ApplicationRecord
  ############################################################################
  # Asociación muchos a uno:soporta muchos periodos pertenecientes a una     #
  #                        comision, para el caso de los periodos anteriores #
  ############################################################################
  belongs_to :commission

  ############################################################################
  # Asociación uno a muchos: soporta que un periodo de comision sea asignado #
  #                          muchas veces en la relación time_sheet_hour     #                                                       #
  ############################################################################
  has_many :time_sheet_hour, dependent: :delete_all
end
