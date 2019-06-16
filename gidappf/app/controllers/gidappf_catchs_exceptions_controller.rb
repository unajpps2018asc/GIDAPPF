class GidappfCatchsExceptionsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:disabled_cookies_detect]
  before_action :set_user_with_default_password, only: [:first_password_detect]

  def disabled_cookies_detect
  end

  def first_password_detect
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_with_default_password
      unless current_user.documents.first.nil?
        @userprofile = current_user.documents.first.profile
      else
        @userprofile = Profile.new
      end
      authorize @userprofile #inicialización del nivel de acceso
    end

end
