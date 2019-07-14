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
# Archivo GIDAPPF/gidappf/app/controllers/user/registrations_controller.rb#
###########################################################################
# frozen_string_literal: true

class User::RegistrationsController < Devise::RegistrationsController
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  #################################################################################
  # Prerequisitos: 1) Valor de Rol Autogestionado cargado en la tabla role        #
  #                2) Setear el valor de la variable de entorno GIDAPPF_SYSADMIN  #
  #                3) Clase LockEmail existente conteniendo el array LIST.        #
  # Devolución: Un usuario logueado y una relación de usercommissionrole asociado #
  #             al valor de administrador o autogestionado                        #
  #################################################################################
  # POST /resource
  def create
    super
    key="GIDAPPF_SYSADMIN"
    selEnv=ENV[key]
    unless selEnv.eql?(User.last.email.to_s)
      if User.where.not(email: LockEmail::LIST).count == 1 then
        r = Role.find_by(level: 40, enabled: true) #Admin
      else
        r = Role.find_by(level: 0, enabled: true) #Autogestionado
      end
      Usercommissionrole.new( role: r, user: User.last, commission: Commission.first ).save
    end
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
