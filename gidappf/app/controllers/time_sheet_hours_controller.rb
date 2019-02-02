class TimeSheetHoursController < ApplicationController
  before_action :set_time_sheet_hour, only: [:show, :edit, :update, :destroy]

  # GET /time_sheet_hours
  # GET /time_sheet_hours.json
  def index
    authorize @time_sheet_hours = TimeSheetHour.all
  end

  # GET /time_sheet_hours/1
  # GET /time_sheet_hours/1.json
  def show
  end

  # GET /time_sheet_hours/new
  def new
    authorize @time_sheet_hour = TimeSheetHour.new
    respond_to do |format|
      format.html { }
      format.json { head :no_content }
    end
  end

  # GET /time_sheet_hours/1/edit
  def edit
    respond_to do |format|
      format.html { }
      format.json { head :no_content }
    end
  end

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
  end

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
  end

  # DELETE /time_sheet_hours/1
  # DELETE /time_sheet_hours/1.json
  def destroy
    authorize @time_sheet_hour.destroy
    respond_to do |format|
      format.html { redirect_to time_sheet_hours_url, notice: 'Time sheet hour was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_time_sheet_hour
      authorize @time_sheet_hour = TimeSheetHour.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def time_sheet_hour_params
      params.require(:time_sheet_hour).permit(:vacancy_id, :time_sheet_id, :from_hour, :from_min, :to_hour, :to_min, :monday, :tuesday, :wednesday, :thursday, :friday, :saturday, :sunday)
    end
end
