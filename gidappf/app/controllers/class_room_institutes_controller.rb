class ClassRoomInstitutesController < ApplicationController
  before_action :set_class_room_institute, only: [:show, :edit, :update, :destroy]

  # GET /class_room_institutes
  # GET /class_room_institutes.json
  def index
    @class_room_institutes = ClassRoomInstitute.all
  end

  # GET /class_room_institutes/1
  # GET /class_room_institutes/1.json
  def show
  end

  # GET /class_room_institutes/new
  def new
    @class_room_institute = ClassRoomInstitute.new
  end

  # GET /class_room_institutes/1/edit
  def edit
  end

  # POST /class_room_institutes
  # POST /class_room_institutes.json
  def create
    @class_room_institute = ClassRoomInstitute.new(class_room_institute_params)
    authorize @class_room_institute

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
  end

  # DELETE /class_room_institutes/1
  # DELETE /class_room_institutes/1.json
  def destroy
    @class_room_institute.destroy
    respond_to do |format|
      format.html { redirect_to class_room_institutes_url, notice: 'Class room institute was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_class_room_institute
      @class_room_institute = ClassRoomInstitute.find(params[:id])
      authorize @class_room_institute
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def class_room_institute_params
      params.require(:class_room_institute).permit(:name, :description, :ubication, :available_from, :available_to, :available_monday, :available_tuesday, :available_wednesday, :available_thursday, :available_friday, :available_saturday, :available_sunday, :available_time, :capacity, :enabled)
    end
end
