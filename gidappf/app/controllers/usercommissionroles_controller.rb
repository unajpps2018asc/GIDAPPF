#############################################################################
# Universidad Nacional Arturo Jauretche                                     #
# Instituto de Ingeniería y Agronomía -Ingeniería en Informática            #
# Práctica Profesional Supervisada Nro 12 - Segundo cuatrimestre de 2018    #
#    <<Gestión Integral de Alumnos Para el Proyecto Fines>>                 #
# Tutores:                                                                  #
#    - UNAJ: Dr. Ing. Morales, Martín                                       #
#    - ORGANIZACIÓN: Ing. Cortes Bracho, Oscar                              #
#    - ORGANIZACIÓN: Mg. Ing. Diego Encinas                                 #
#    - TAPTA: Dra. Ferrari, Mariela                                         #
# Autor: Ap. Daniel Rosatto <danielrosatto@gmail.com>                       #
# Archivo GIDAPPF/gidappf/app/controllers/usercommissionroles_controller.rb #
#############################################################################
class UsercommissionrolesController < ApplicationController
  before_action :set_usercommissionrole, only: [:show, :edit, :update]

  # GET /usercommissionroles/1
  # GET /usercommissionroles/1.json
  def show
  end

  # GET /usercommissionroles/1/edit
  def edit
    #############################################################################
    # Se comenta el algoritmo que redirige al formulario de edición             #
    #############################################################################
    # @usercommissionrole.role_id=params[:radio_selected]
    ################################################################################
    # Se deben comentar las 2 siguientes líneas en caso de necesitar el formulario #
    ################################################################################
    Usercommissionrole.find_by(id: @usercommissionrole.id).update(role_id: params[:radio_selected])
    redirect_to setsusersaccess_settings_path
  end

  # PATCH/PUT /usercommissionroles/1
  # PATCH/PUT /usercommissionroles/1.json
  def update
    #############################################################################
    # Se comenta el algoritmo que redirige al formulario de edición             #
    #############################################################################
    # respond_to do |format|
    #   if @usercommissionrole.update(usercommissionrole_params)
    #     format.html { redirect_to @usercommissionrole, notice: 'Usercommissionrole was successfully updated.' }
    #     format.json { render :show, status: :ok, location: @usercommissionrole }
    #   else
    #     format.html { render :edit }
    #     format.json { render json: @usercommissionrole.errors, status: :unprocessable_entity }
    #   end
    # end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_usercommissionrole
      @usercommissionrole = Usercommissionrole.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def usercommissionrole_params
      params.require(:usercommissionrole).permit(:role_id, :user_id, :commission_id,:radio_selected)
    end
end
