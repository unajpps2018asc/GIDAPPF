###########################################################################
# Universidad Nacional Arturo Jauretche                                   #
# Instituto de Ingeniería y Agronomía -Ingeniería en Informática          #
# Práctica Profesional Supervisada Nro 12 - Segundo cuatrimestre de 2018  #
#       <<Gestión Integral de Alumnos Para el Proyecto Fines>>            #
# Tutores:                                                                #
#       - UNAJ: Dr. Ing. Morales, Martín                                  #
#       - INSTITUCION: Ing. Cortes Bracho, Oscar                          #
#       - TAPTA: Dra. Ferrari, Mariela                                    #
# Autor: Ap. Daniel Rosatto <danielrosatto@gmail.com>                     #
###########################################################################
#class ApplicationController < ActionController::Base
#  protect_from_forgery with: :exception
#end
class ApplicationController < ActionController::Base
	protect_from_forgery with: :exception
	before_action :authenticate_user!
end
