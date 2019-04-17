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

  ###################################################################################
  # Prerequisitos:                                                                  #
  #           1) Modelo de datos inicializado.                                      #
  #           2) ProfileKey numero 23 con valor key reprecentando trayecto.         #
  #           3) ProfileKey numero 24 con valor key reprecentando turno desde.      #
  #           4) ProfileKey numero 25 con valor key reprecentando turno hasta.      #
  #           5) Profile numero 1 es una plantilla, no tiene valores, solo claves.  #
  # Devolución: Accion que permite seleccionar comisiones dentro del periodo actual #
  #      hasta periodos que finalizan en 3 anos por un lado. Por otro Aulas en forma#
  #      agrupada con los perfiles que podrian ser asignadoss #
  #        o ya estan asignados a estas comisiones. La vista proporciona el link a  #
  #        la modificacion de la seleccion causada por el usuario.                  #
  ###################################################################################
  # GET /time_sheet_hours
  # GET /time_sheet_hours.json
  def index
    @time_sheet_hours = TimeSheetHour.all
    authorize @time_sheet_hours
    @time_sheet_hours -= @time_sheet_hours.where(from_hour: 0, from_min: 0, to_hour: 0, to_min: 0)
    @time_sheets = TimeSheet.where(end_date: Date.today .. 36.month.after).where(enabled:true).where.not(commission: Commission.first)
    @class_room_institutes = ClassRoomInstitute.where(enabled:true).where.not(available_to: 24.month.after .. 36.month.after)
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

  # post /time_sheet_hours/multiple_new/params
  def multiple_new
    @matters=Matter.where(enable: true)
    arr=time_sheet_each_vacancy(get_ts_and_cri,"id_cri","id_ts")
    unless arr.nil? || arr.first.empty? || arr.last.empty? then
      authorize @time_sheet_hour=TimeSheetHour.new(
          time_sheet_id: arr.last.first.id,
          vacancy_id: arr.first.first.vacancies.first.id,
          matter_id: params[:matter_id].to_i,
          from_hour: params[:from_hour],
          from_min: params[:from_min],
          to_hour: params[:to_hour],
          to_min: params[:to_min],
          monday: params[:monday],
          tuesday: params[:tuesday],
          wednesday: params[:wednesday],
          thursday: params[:thursday],
          friday: params[:friday],
          saturday: params[:saturday],
          sunday: params[:sunday]
        )
      respond_to do |format|
        unless !@time_sheet_hour.save
          msg = "Created TSH{ ts_id=#{arr.last.first.id} vac_id=#{arr.first.first.vacancies.first.id} fh=#{@time_sheet_hour.from_hour} fm=#{@time_sheet_hour.from_min} th=#{@time_sheet_hour.to_hour} tm=#{@time_sheet_hour.to_min} mo=#{@time_sheet_hour.monday} tu=#{@time_sheet_hour.tuesday} we=#{@time_sheet_hour.wednesday} th=#{@time_sheet_hour.thursday} fr=#{@time_sheet_hour.friday} sa=#{@time_sheet_hour.saturday} su=#{@time_sheet_hour.sunday}}"
          rest_tsh(arr,@time_sheet_hour)
          format.html { redirect_to time_sheet_hours_path, notice: msg }
          format.json { render :renew_all, status: :ok}
        else
          format.html { render :multiple_new}
          format.json { render json: @time_sheet_hour.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_back fallback_location: '/', allow_other_host: false, notice: 'Unrelationable_entitys.'
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
      params.require(:time_sheet_hour).permit(:matter_id, :vacancy_id, :time_sheet_id, :from_hour, :from_min, :to_hour, :to_min, :monday, :tuesday, :wednesday, :thursday, :friday, :saturday, :sunday)
    end

    def params_to_hash
      unless params[:map_sel].nil? then
        tomap=params[:map_sel]
        unless tomap.empty? && !TimeSheetHourObject.instance.elements[tomap.first].nil? then
          TimeSheetHourObject.instance.elements[tomap.first]=tomap.last
        end
      end
    end

    def get_ts_and_cri
      TimeSheetHourObject.instance.elements
    end
    helper_method :get_ts_and_cri

    def time_sheet_each_vacancy(hash,kcri,kts)
      out=nil
      unless hash.nil? then
        time_sheets=[]
        class_room_institutes=[]
        hash.each do |k,v|
          if k.first(kcri.length).eql?(kcri) then
            class_room_institutes.push(ClassRoomInstitute.find(v))
          elsif k.first(kts.length).eql?(kts) then
            time_sheets.push(TimeSheet.find(v))
          end
        end
        if class_room_institutes.count == time_sheets.count then
          out=[class_room_institutes, time_sheets]
        end
      end
      out
    end

    def rest_tsh(cri_ts_arr,ref)
      vacancy_cri=[]
      cri_ts_arr.first.each do |c|
        vacancy_cri << c.vacancies
      end
      create_by_groups(cri_ts_arr.last, vacancy_cri ,ref)
    end

    def create_by_groups(ts_commission, vacancy_cri ,ref)
      if ts_commission.count == vacancy_cri.count then
        vacancy_cri.each do |group_vacancy|
          time_sheet_of_commission = ts_commission.shift
          group_vacancy.each do |v|
            unless !TimeSheetHour.find_by(
              time_sheet_id: time_sheet_of_commission.id,
              matter_id: ref.matter_id,
              vacancy_id: v.id,
              from_min: ref.from_min,
              to_hour: ref.to_hour,
              to_min: ref.to_min,
              monday: ref.monday,
              tuesday: ref.tuesday,
              wednesday: ref.wednesday,
              thursday: ref.thursday,
              friday: ref.friday,
              saturday: ref.saturday,
              sunday: ref.sunday
            ).nil? then
              TimeSheetHour.new(
                time_sheet_id: time_sheet_of_commission.id,
                matter_id: ref.matter_id,
                vacancy_id: v.id,
                from_hour: ref.from_hour,
                from_min: ref.from_min,
                to_hour: ref.to_hour,
                to_min: ref.to_min,
                monday: ref.monday,
                tuesday: ref.tuesday,
                wednesday: ref.wednesday,
                thursday: ref.thursday,
                friday: ref.friday,
                saturday: ref.saturday,
                sunday: ref.sunday
              ).save
            end
          end
        end
      end
    end

end#class
