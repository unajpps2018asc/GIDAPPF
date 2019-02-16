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
# Archivo GIDAPPF/gidappf/app/controllers/time_sheet_hours_controller.rb  #
###########################################################################
class TimeSheetHoursController < ApplicationController
  before_action :set_time_sheet_hour, only: [:show, :edit, :update, :destroy]

  # GET /time_sheet_hours
  # GET /time_sheet_hours.json
  def index
    authorize @time_sheet_hours = TimeSheetHour.all
    @time_sheet_hours -= @time_sheet_hours.where(from_hour: 0, from_min: 0, to_hour: 0, to_min: 0)
    @time_sheets = TimeSheet.where(end_date: Date.today .. 15.month.after).where(enabled:true)
    @class_room_institutes = ClassRoomInstitute.where(enabled:true)
    if !params[:map_sel].nil? then
      params_to_hash
    elsif params[:map_sel].nil? then
      unless TimeSheetHourObject.instance.nil? || TimeSheetHourObject.instance.elements.nil?
        TimeSheetHourObject.instance.elements.clear
      end
    end
    @map_sel=TimeSheetHourObject.instance
  end#index

  # GET /time_sheet_hours/1
  # GET /time_sheet_hours/1.json
  def show
  end#show

  # GET /time_sheet_hours/new
  def new
    authorize @time_sheet_hour = TimeSheetHour.new
    respond_to do |format|
      format.html { }
      format.json { head :no_content }
    end
  end#new

  # GET /time_sheet_hours/1/edit
  def edit
    respond_to do |format|
      format.html { }
      format.json { head :no_content }
    end
  end#edit

  # POST /time_sheet_hours
  # POST /time_sheet_hours.json
  def create
    authorize @time_sheet_hour = TimeSheetHour.new(time_sheet_hour_params)
    respond_to do |format|
      if @time_sheet_hour.save
        format.html { redirect_to @time_sheet_hour, notice: 'Time sheet hour was successfully created.' }
        format.json { render :show, status: :created, location: @time_sheet_hour }
      else
        format.html { render :new }
        format.json { render json: @time_sheet_hour.errors, status: :unprocessable_entity }
      end
    end
  end#create

  # PATCH/PUT /time_sheet_hours/1
  # PATCH/PUT /time_sheet_hours/1.json
  def update
    respond_to do |format|
      if @time_sheet_hour.update(time_sheet_hour_params)
        format.html { redirect_to @time_sheet_hour, notice: 'Time sheet hour was successfully updated.' }
        format.json { render :show, status: :ok, location: @time_sheet_hour }
      else
        format.html { render :edit }
        format.json { render json: @time_sheet_hour.errors, status: :unprocessable_entity }
      end
    end
  end#update

  # DELETE /time_sheet_hours/1
  # DELETE /time_sheet_hours/1.json
  def destroy
    authorize @time_sheet_hour.destroy
    respond_to do |format|
      format.html { redirect_to time_sheet_hours_url, notice: 'Time sheet hour was successfully destroyed.' }
      format.json { head :no_content }
    end
  end#destroy

  def multiple_new
    c=params[:to_hours_news]
    unless c.nil? then

    else
      redirect_back fallback_location: '/', allow_other_host: false, notice: 'Select any pair commission, class_room_institute'
    end
    respond_to do |format|
      format.html { }
      format.json { head :no_content }
    end
  end

  def disable_cri(cri_id)
    unless @map_sel.nil?||@map_sel.elements.nil? then
      !@map_sel.elements["id_cri#{cri_id}"].nil?
    else
      false
    end
  end
  helper_method :disable_cri

  def disable_ts(ts_id)
    unless @map_sel.nil?||@map_sel.elements.nil? then
      !@map_sel.elements["id_ts#{ts_id}"].nil?
    else
      false
    end
  end
  helper_method :disable_ts

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_time_sheet_hour
      authorize @time_sheet_hour = TimeSheetHour.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def time_sheet_hour_params
      params.require(:time_sheet_hour).permit(:vacancy_id, :time_sheet_id, :from_hour, :from_min, :to_hour, :to_min, :monday, :tuesday, :wednesday, :thursday, :friday, :saturday, :sunday)
    end

    def params_to_hash
      unless params[:map_sel].nil? then
        tomap=params[:map_sel]
        unless tomap.empty? && !TimeSheetHourObject.instance.elements[tomap.first].nil? then
          TimeSheetHourObject.instance.elements[tomap.first]=tomap.last
        end
      end
    end

    def hash_to_arr
      arr=[]
      TimeSheetHourObject.instance.elements.each do |key, value|
        arr << [key,value]
      end
      arr
    end
    helper_method :hash_to_arr
end#class
