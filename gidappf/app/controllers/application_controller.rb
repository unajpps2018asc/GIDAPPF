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
# Archivo GIDAPPF/gidappf/app/controllers/application_controller.rb       #
###########################################################################
class ApplicationController < ActionController::Base
	include Pundit #requerimiento para establecer el control de acceso
	protect_from_forgery with: :exception
	before_action :authenticate_user!
		##########################################################################
		# Se  incluye el manejo de excepción provocado por intento de acceso     #
		# si autorización segun las reglas de Pundit                             #
		##########################################################################
		rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

		private

		###########################################################################
		# Algoritmo que  muestra el mensaje de intento no autorizado de acceso    #
		# El mensaje lo carga automáticamente desde gidappf/config/locales/en.yml #
		###########################################################################
		def user_not_authorized(exception)
			policy_name = exception.policy.class.to_s.underscore

			flash[:error] = t "#{policy_name}.#{exception.query}", scope: "pundit", default: :default
			redirect_to root_path
		end
end
