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
# Archivo GIDAPPF/gidappf/app/controllers/time_sheets_controller.rb       #
###########################################################################
class TimeSheetsController < ApplicationController
  before_action :set_time_sheet, only: [:show, :edit, :update, :destroy]

  # GET /time_sheets
  # GET /time_sheets.json
  def index
    authorize @time_sheets = TimeSheet.where(start_date: 13.months.ago .. Date.today, end_date: 1.month.ago .. Date.today).where(enabled:true)
    @time_sheets1 = TimeSheet.all
  end

  # GET /time_sheets/1
  # GET /time_sheets/1.json
  def show
  end

  ##############################################################################
  # Prerequisitos:                                                             #
  #           1) Modelo de datos inicializado.                                 #
  #           2)Asociacion un Commission a muchos TimeSheet registrada en el   #
  #             modelo.                                                        #
  #           3) Recepción de datos de Commission por parámetros url.          #
  # Devolución: Registro de TimeSheet creado segun parametros del formulario,o #
  #             sino el mensaje de error con detalles de validación.           #
  ##############################################################################
  # GET /time_sheets/1/edit
  def edit
    params[:commission_id]=@time_sheet.commission_id.to_s
  end

  # POST /time_sheets
  # POST /time_sheets.json
  def create
    authorize @time_sheet = TimeSheet.new(time_sheet_params)

    respond_to do |format|
      if @time_sheet.save
        format.html { redirect_to @time_sheet, notice: 'Time sheet was successfully created.' }
        format.json { render :show, status: :created, location: @time_sheet }
      else
        params[:commission_id]=@time_sheet.commission_id.to_s
        params[:commission_name]=Commission.find(params[:commission_id].to_i).name
        format.html { render :associate, params}
        format.json { render json: @time_sheet.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /time_sheets/1
  # PATCH/PUT /time_sheets/1.json
  def update
    respond_to do |format|
      if @time_sheet.update(time_sheet_params)
        format.html { redirect_to @time_sheet, notice: 'Time sheet was successfully updated.' }
        format.json { render :show, status: :ok, location: @time_sheet }
      else
        format.html { render :edit }
        format.json { render json: @time_sheet.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /time_sheets/1
  # DELETE /time_sheets/1.json
  def destroy
    @time_sheet.destroy
    respond_to do |format|
      format.html { redirect_to time_sheets_url, notice: 'Time sheet was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  ############################################################################
  # Prerequisitos:                                                           #
  #           1) Modelo de datos inicializado.                               #
  #           2)Asociacion un Commission a muchos TimeSheet registrada en el #
  #             modelo.                                                      #
  # Devolución: Registro de TimeSheet creado segun parametros del formulario #
  #             ,o sino el mensaje de error con detalles de validación.      #
  ############################################################################
  def associate
    c=params[:commission_id]
    unless c.nil?
      if create_period?(c) then
        @commission=Commission.find(c)
        authorize @time_sheet = TimeSheet.new(
          commission_id: c,
          end_date: @commission.end_date,
          enabled: true
        )
      else
        redirect_back fallback_location: '/', allow_other_host: false, notice: 'Time sheet allready exist.'
      end
    else
      redirect_back fallback_location: '/', allow_other_host: false, errors: 'Commission not exist'
    end
    respond_to do |format|
      format.html { }
      format.json { head :no_content }
    end
  end

  ##############################################################################
  # Prerequisitos:                                                             #
  #           1) Modelo de datos inicializado.                                 #
  #           2)Asociacion un usuario a muchas comisiones registrada           #
  #             en el modelo.                                                  #
  # Devolución: Nuevos registro de TimeSheet con los parametros del formulario #
  #             y relacionado con commissions encontradas por el algoritmo.    #
  ##############################################################################
  def renew_all
    @sd=params[:sd]
    @ed=params[:ed]
    authorize @time_sheets=TimeSheet.where(start_date: 13.months.ago .. Date.today, end_date: 1.month.ago .. Date.today).where(enabled:true)
    respond_to do |format|
      unless @time_sheets.empty?||@sd.nil?||@ed.nil?||@sd>@ed
        @time_sheets.each do |e|
          if create_period?(e.commission_id) then
            e.update(enabled: false)
            TimeSheet.new(commission_id: e.commission_id, start_date: @sd, end_date: @ed, enabled: true).save
          end
        end
        format.html { redirect_to time_sheets_path, notice: 'Time sheets was successfully renewed.' }
        format.json { render :renew_all, status: :ok}
      else
        format.html { render :renew_all}
        format.json { render json: nil, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_time_sheet
      authorize @time_sheet = TimeSheet.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def time_sheet_params
      params.require(:time_sheet).permit(:commission_id, :start_date, :end_date, :enabled)
    end

    ###############################################################################
    # Prerequisitos:                                                              #
    #           1) Modelo de datos inicializado.                                  #
    # Devolución: True si la sentencia es  cumplida por los registros, sino false #
    ###############################################################################
    def create_period?(commission)
      x=TimeSheet.where(commission_id: commission, end_date:  1.month.after .. 10.years.after).where(enabled: true)
      x.nil? || x.empty?
    end
end
