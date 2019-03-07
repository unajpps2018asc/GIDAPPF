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

		if Rails.env.development?
	    Rack::MiniProfiler.authorize_request
		end

		private

		#########################################################################################
	  # Prerequisitos: 1) Modelo Role con instancia creada con level: 10, enabled: false.     #
	  #               2) Policy con la implementacion adecuada a las acciones desarrolladas.  #
	  # Devolución: Respuesta a la falta de acceso a la accion accedida, detectada. Se        #
	  #             captura la exepción pundit y se redirige a cambio de password si la falta #
	  #             de autorización se debe al password obsoleto                              #
	  #########################################################################################
		def user_not_authorized(exception)
			policy_name = exception.policy.class.to_s.underscore

			flash[:error] = t "#{policy_name}.#{exception.query}", scope: "pundit", default: :default
			if current_user.usercommissionroles.first.role.id == Role.find_by(level: 10, enabled: false).id then
				reset_session
				redirect_to new_user_password_path, notice: "Enter email to change passsword..."
			else
				redirect_to root_path
		  end
		end
end
