# frozen_string_literal: true

class User::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]
  after_action :first_form_password_change, only: :create
  #
  # # GET /resource/sign_in
  # def new
  #   super
  # end
  #
  # # POST /resource/sign_in
  def create
    super
  end
  #
  # DELETE /resource/sign_out
  def destroy
    super
    flash.delete(:notice)
  end
  #
  # protected
  #
  # # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
  private

  ####################################################################################
  # Prerequisitos: 1) Modelo Role con instancia creada con level: 10, enabled: false #
  #               2) Modelo Role con instancia creada con level: 10, enabled: true   #
  # Devolución: Un usercommissionrole asociado al usuario con el valor de Ingresante #
  #             del tipo enabled segun el rol anterior y si fué  actializado         #
  #             recientemente debido al cambio de password.                          #
  ####################################################################################
  def first_form_password_change
    old_role=current_user.usercommissionroles.first.role
    if (Time.now - Time.parse(current_user.updated_at.to_s)).second < 90 && !old_role.enabled then
      current_user.usercommissionroles.first.update(
        role: Role.find_by(level: old_role.level, enabled: true)
      )
    end
  end
end
