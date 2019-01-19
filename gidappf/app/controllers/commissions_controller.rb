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
  #             y relacionado con el usuario actual como su creador.         #
  ############################################################################
  # POST /commissions
  # POST /commissions.json
  def create
    @commission = Commission.new(commission_params)
    authorize @commission #inicialización del nivel de acceso
    @commission.update(user: current_user)

    respond_to do |format|
      if @commission.save
        format.html { redirect_to @commission, notice: 'Commission was successfully created.' }
        format.json { render :show, status: :created, location: @commission }
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
      @commission.time_sheet.destroy_all
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
    set_time_sheet
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def commission_params
    params.require(:commission).permit(:name, :description, :start_date, :end_date)
  end

  ##########################################################################
  # Metodo privado para decodificar periodos y horarios en select          #
  # Devuelve: @selection_period y @selection_hour con las frases asignadas #
  #           segun el codigo interno de Vacancy y TimeSheet               #
  ##########################################################################
  def set_new
    # @selection_hour = [
    #   ['Desde 8 a 10 hs.', 810],['Desde 10 a 12 hs.', 1012],
    #   ['Desde 12 a 14 hs.', 1214],['Desde 14 a 16 hs.', 1416],
    #   ['Desde 16 a 18 hs.', 1618],['Desde 18 a 20 hs.', 1820],
    #   ['Desde 20 a 22 hs.', 2022],['Desde 8 a 12 hs.', 812],
    #   ['De 0 a 12 hs.', 12],['De 0 a 24 hs.', 24],
    #   ['De 10 a 22 hs.', 1022],['De 16 a 24 hs.', 1624]
    # ]
  end

  ##########################################################################
  # Metodo privado para controlar el modelo TimeSheet                      #
  # Devuelve: Intervalo de tiempo para generar un TimeSheet en @fdate y en #
  #           @tdate                                                       #
  ##########################################################################
  def set_time_sheet
    # ts = TimeSheet.find_by(commission: @commission)
    # unless ts
    #   @ts_start = Date.today
    #   @ts_end = Date.today
    # else
      @ts_start = TimeSheet.find_by(commission: @commission).start_date
      @ts_end = TimeSheet.find_by(commission: @commission).end_date
    # end
   end

  ###############################################################################
  # Metodo privado para controlar el modelo TimeSheetHour                       #
  # Devuelve: Cantidad de instancias de vacantes asociadas con el aula segun el #
  #           codigo de la capacidad guardado en la relacion                    #
  ###############################################################################
  def set_time_sheet_hour
  end
end
