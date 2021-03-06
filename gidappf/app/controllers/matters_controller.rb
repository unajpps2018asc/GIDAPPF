class MattersController < ApplicationController
  before_action :set_matter, only: [:show, :edit, :update, :destroy]
  before_action :set_selection_trayect, only: [:new, :edit]

  # GET /matters
  # GET /matters.json
  def index
    if RoleAccess.get_role_access(current_user) > 30.0
      @matters = Matter.all
    else
      @matters = Matter.where(enable: true)
    end
    authorize @matters
    @matters = Matter.all
  end

  # GET /matters/1
  # GET /matters/1.json
  def show
  end

  # GET /matters/new
  def new
    @matter = Matter.new
    authorize @matter
    respond_to do |format|
      format.html { }
      format.json { head :no_content }
    end
  end

  # GET /matters/1/edit
  def edit
    respond_to do |format|
      format.html { }
      format.json { head :no_content }
    end
  end

  # POST /matters
  # POST /matters.json
  def create
    @matter = Matter.new(matter_params)
    authorize @matter

    respond_to do |format|
      if @matter.save
        format.html { redirect_to @matter, notice: t('body.gidappf_entity.matter.action.new.notice') }
        format.json { render :show, status: :created, location: @matter }
      else
        format.html { render :new }
        format.json { render json: @matter.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /matters/1
  # PATCH/PUT /matters/1.json
  def update
    respond_to do |format|
      if @matter.update(matter_params)
        format.html { redirect_to @matter, notice: t('body.gidappf_entity.profile.action.update.notice') }
        format.json { render :show, status: :ok, location: @matter }
      else
        format.html { render :edit }
        format.json { render json: @matter.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /matters/1
  # DELETE /matters/1.json
  def destroy
    @matter.destroy
    respond_to do |format|
      format.html { redirect_to matters_url, notice: t('body.gidappf_entity.matter.action.destroy.notice') }
      format.json { head :no_content }
    end
  end

  def set_selection_trayect
    @selection_trayect=[
      ['Primero', "PRIMERO"],['Segundo', "SEGUNDO"],['Tercero', "TERCERO"]
    ]
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_matter
      @matter = Matter.find(params[:id])
      authorize @matter
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def matter_params
      params.require(:matter).permit(:name, :description, :trayect, :enable)
    end
end
