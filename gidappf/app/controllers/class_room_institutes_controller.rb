###############################################################################
# Universidad Nacional Arturo Jauretche                                       #
# Instituto de Ingeniería y Agronomía -Ingeniería en Informática              #
# Práctica Profesional Supervisada Nro 12 - Segundo cuatrimestre de 2018      #
#    <<Gestión Integral de Alumnos Para el Proyecto Fines>>                   #
# Tutores:                                                                    #
#    - UNAJ: Dr. Ing. Morales, Martín                                         #
#    - ORGANIZACIÓN: Ing. Cortes Bracho, Oscar                                #
#    - ORGANIZACIÓN: Mg. Ing. Diego Encinas                                   #
#    - TAPTA: Dra. Ferrari, Mariela                                           #
# Autor: Ap. Daniel Rosatto <danielrosatto@gmail.com>                         #
# Archivo GIDAPPF/gidappf/app/controllers/class_room_institutes_controller.rb #
###############################################################################
class ClassRoomInstitutesController < ApplicationController
  before_action :set_class_room_institute, only: [:show, :edit, :update, :destroy, :parametrize]

  # GET /class_room_institutes
  # GET /class_room_institutes.json
  ##############################################################################
  # Acción diferenciada por get_role_access si es o no mayor a 30              #
  ##############################################################################
  def index
    if RoleAccess.get_role_access(current_user) > 30.0
      @class_room_institutes = ClassRoomInstitute.all
    else
      @class_room_institutes = ClassRoomInstitute.where(enabled: true)
    end
    authorize @class_room_institutes
  end

  # GET /class_room_institutes/1
  # GET /class_room_institutes/1.json
  def show
  end

  # GET /class_room_institutes/new
  def new
    set_new
    @class_room_institute = ClassRoomInstitute.new
    authorize @class_room_institute
    respond_to do |format|
      format.html { }
      format.json { head :no_content }
    end
  end

  # GET /class_room_institutes/1/edit
  def edit
    respond_to do |format|
      format.html { }
      format.json { head :no_content }
    end
  end

  # POST /class_room_institutes
  # POST /class_room_institutes.json
  def create
    @class_room_institute = ClassRoomInstitute.new(class_room_institute_params)
    authorize @class_room_institute
    set_vacancies

    respond_to do |format|
      if @class_room_institute.save
        format.html { redirect_to @class_room_institute, notice: 'Class room institute was successfully created.' }
        format.json { render :show, status: :created, location: @class_room_institute }
      else
        format.html { render :new }
        format.json { render json: @class_room_institute.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /class_room_institutes/1
  # PATCH/PUT /class_room_institutes/1.json
  def update
    respond_to do |format|
      if @class_room_institute.update(class_room_institute_params)
        format.html { redirect_to @class_room_institute, notice: 'Class room institute was successfully updated.' }
        format.json { render :show, status: :ok, location: @class_room_institute }
      else
        format.html { render :edit }
        format.json { render json: @class_room_institute.errors, status: :unprocessable_entity }
      end
    end
    set_vacancies
  end

  # DELETE /class_room_institutes/1
  # DELETE /class_room_institutes/1.json
  def destroy
    begin
      @class_room_institute.destroy
    rescue ActiveRecord::InvalidForeignKey
      @class_room_institute.vacancies.destroy_all
      @class_room_institute.destroy
    end
    respond_to do |format|
      format.html { redirect_to class_room_institutes_url, notice: 'Class room institute was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # GET /class_room_institutes/parametrize/1
  # GET /class_room_institutes/parametrize/1.json
  def parametrize
    respond_to do |format|
      format.html {
        redirect_to time_sheet_hours_url(
          map_sel: [
            "id_cri#{@class_room_institute.id}",
            @class_room_institute.id.to_s
            ]
          ),
          notice: "Class room institute #{@class_room_institute.name}."
        }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_class_room_institute
      @class_room_institute = ClassRoomInstitute.find(params[:id])
      authorize @class_room_institute
      set_new
      set_ctl_opt
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def class_room_institute_params
      params.require(:class_room_institute).permit(:name, :description, :ubication, :available_from, :available_to, :available_monday, :available_tuesday, :available_wednesday, :available_thursday, :available_friday, :available_saturday, :available_sunday, :available_time, :capacity, :enabled)
    end

    #############################################################################
    # Metodo privado para decodificar vacantes y disponibilidad en la acc. show #
    # Devuelve: @ctl_capacity y @ctl_available_time con las frases asignadas    #
    #           segun el codigo interno de Vacancy y TimeSheet                  #
    #############################################################################
    def set_ctl_opt
      x=@class_room_institute.capacity
      case x
        when 812
          @ctl_capacity='Máximo 12 personas.'
        when 1315
          @ctl_capacity='Máximo 15 personas.'
        when 1620
          @ctl_capacity='Máximo 20 personas.'
        when 2132
          @ctl_capacity='Máximo 32 personas.'
        when 3300
          @ctl_capacity='Máximo 50 personas.'
        else
          @ctl_capacity="Sin frase en la opción: #{x}."
      end
      x=@class_room_institute.available_time
      case x
        when 812
          @ctl_available_time='Disponible de 8 a 12 hs.'
        when 12
          @ctl_available_time="Disponible de 0 a 12 hs."
        when 24
          @ctl_available_time="Disponible las 24 hs."
        when 1022
          @ctl_available_time="Disponible de 10 a 22 hs."
        when 1624
          @ctl_available_time="Disponible de 16 a 24 hs."
        else
          @ctl_available_time="Sin frase en la opción: #{x}."
      end
    end

  #############################################################################
  # Metodo privado para decodificar vacantes y disponibilidad en select       #
  # Devuelve: @selection_capacity y @selection_available_time con las         #
  #           frases asignadas segun el codigo interno de Vacancy y TimeSheet #
  #############################################################################
  def set_new
    @selection_capacity=[
      ['8 a 12 personas', 812],['13 a 15 personas', 1315],['16 a 20 personas', 1620],
      ['21 a 32 personas', 2132],['mas de 50 personas', 3300]
    ]
    @selection_available_time=[
      ['Desde 8 a 12 hs.', 812],['De 0 a 12 hs.', 12],['De 0 a 24 hs.', 24],
      ['De 10 a 22 hs.', 1022],['De 16 a 24 hs.', 1624]
    ]
  end

  ###############################################################################
  # Metodo privado para controlar el modelo Vacancy                             #
  # Devuelve: Cantidad de instancias de vacantes asociadas con el aula segun el #
  #           codigo de la capacidad guardado en la relacion                    #
  ###############################################################################
  def set_vacancies
    x = @class_room_institute.capacity
    c=Vacancy.where(class_room_institute: @class_room_institute).count
    if c === nil then c = 0 end
    case x
      when 812
        y=12 - c
      when 1315
        y=15 - c
      when 1620
        y=20 - c
      when 2132
        y=32 - c
      when 3300
        y=60 - c
      else
        y=0
        flash.now[:alert] = "Vacancy error option: #{x.to_s}."
    end
    if y > 0 then y.times {|i|
      Vacancy.new(class_room_institute: @class_room_institute, enabled: @class_room_institute.enabled).save}
    elsif y < 0
      Vacancy.where(class_room_institute: @class_room_institute).limit(y.abs).destroy_all
    end
  end
end
