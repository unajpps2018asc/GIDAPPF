require 'role_access'
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
	include RoleAccess
	###############################################
	# :get_user_links, definido en RoleAccess     #
	###############################################
	helper_method :get_user_links
	protect_from_forgery with: :exception
	# protect_from_forgery  unless: -> { request.format.json? }
	prepend_before_action :authenticate_user!
		##########################################################################
		# Se  incluye el manejo de excepción provocado por intento de acceso     #
		# si autorización segun las reglas de Pundit                             #
		##########################################################################
		rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

	  rescue_from ActionController::InvalidAuthenticityToken, with: :unblock_cookies

		rescue_from ActiveRecord::RecordNotFound, with: :not_record_found

		def after_sign_out_path_for(*)
	    new_user_session_path
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
			if !current_user.usercommissionroles.first.role.enabled then
				redirect_to gidappf_catchs_exceptions_first_password_detect_path
			else
				redirect_to root_path
		  end
		end

		def unblock_cookies
			redirect_to gidappf_catchs_exceptions_disabled_cookies_detect_path
		end

		def not_record_found
			redirect_to gidappf_catchs_exceptions_not_record_found_detect_path
		end
end
