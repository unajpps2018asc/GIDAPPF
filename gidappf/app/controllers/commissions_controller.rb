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
# Archivo GIDAPPF/gidappf/app/controllers/commissions_controller.rb       #
###########################################################################
class CommissionsController < ApplicationController
  before_action :set_commission, only: [:show, :edit, :update, :destroy]

  # GET /commissions
  # GET /commissions.json
  def index
    @commissions = Commission.all
    authorize @commissions
  end

  # GET /commissions/1
  # GET /commissions/1.json
  def show
  end

  # GET /commissions/new
  def new
    @commission = Commission.new
  end

  # GET /commissions/1/edit
  def edit
  end

  ############################################################################
  # Prerequisitos:                                                           #
  #           1) Modelo de datos inicializado.                               #
  #           2)Asociacion un usuario a muchas comisiones registrada         #
  #             en el modelo.                                                #
  # Devolución: Nuevo registro de comision con los parametros del formulario #
  #             y relacionado con el usuario actual como su creador, también #
  #             entrega la redirección a la acción time_sheets_associate.    #
  ############################################################################
  # POST /commissions
  # POST /commissions.json
  def create
    @commission = Commission.new(commission_params)
    authorize @commission #inicialización del nivel de acceso
    @commission.update(user: current_user)

    respond_to do |format|
      if @commission.save
        # format.html { redirect_to @commission, notice: 'Commission was successfully created.' }
        # format.json { render :show, status: :created, location: @commission }
        format.html { redirect_to time_sheets_associate_path commission_id: @commission.id.to_s, commission_name: @commission.name, notice: 'Commission was successfully created.' }
        format.json { head :no_content }
      else
        format.html { render :new }
        format.json { render json: @commission.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /commissions/1
  # PATCH/PUT /commissions/1.json
  def update
    respond_to do |format|
      if @commission.update(commission_params)
        format.html { redirect_to @commission, notice: 'Commission was successfully updated.' }
        format.json { render :show, status: :ok, location: @commission }
      else
        format.html { render :edit }
        format.json { render json: @commission.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /commissions/1
  # DELETE /commissions/1.json
  def destroy
    begin
      @commission.destroy
    rescue ActiveRecord::InvalidForeignKey
      @commission.time_sheets.destroy_all
      @commission.destroy
    end
    respond_to do |format|
      format.html { redirect_to commissions_url, notice: 'Commission was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  ###########################################################################
  # Prerequisitos:                                                          #
  #           1) Modelo de datos inicializado.                              #
  #           2)Asociacion un usuario a muchas comisiones registrada        #
  #             en el modelo.                                               #
  # Devolución: Variable global @commission inicializado con los parametros #
  #             y relacionado con el usuario actual como su creador.        #
  ###########################################################################
  # Use callbacks to share common setup or constraints between actions.
  def set_commission
    @commission = Commission.find(params[:id])
    authorize @commission #inicialización del nivel de acceso
    @commission.update(user: current_user)
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def commission_params
    params.require(:commission).permit(:name, :description, :start_date, :end_date)
  end
end
