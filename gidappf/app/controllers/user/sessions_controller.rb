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
  # # DELETE /resource/sign_out
  # def destroy
  #   super
  # end
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
    if (Time.now - Time.parse(current_user.updated_at.to_s)).second < 90 &&
      current_user.usercommissionrole.first.role_id == Role.find_by(level: 10, enabled: false).id
      then
      current_user.usercommissionrole.first.update(role_id: Role.find_by(level: 10, enabled: true).id)
    end
  end
end
