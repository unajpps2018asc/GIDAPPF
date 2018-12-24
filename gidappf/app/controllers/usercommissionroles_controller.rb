class UsercommissionrolesController < ApplicationController
  before_action :set_usercommissionrole, only: [:show, :edit, :update, :destroy]

  # GET /usercommissionroles
  # GET /usercommissionroles.json
  def index
    @usercommissionroles = Usercommissionrole.all
  end

  # GET /usercommissionroles/1
  # GET /usercommissionroles/1.json
  def show
  end

  # GET /usercommissionroles/new
  def new
    @usercommissionrole = Usercommissionrole.new
  end

  # GET /usercommissionroles/1/edit
  def edit
    @usercommissionrole.role_id=params[:radio_selected]
  end

  # POST /usercommissionroles
  # POST /usercommissionroles.json
  def create
    @usercommissionrole = Usercommissionrole.new(usercommissionrole_params)

    respond_to do |format|
      if @usercommissionrole.save
        format.html { redirect_to @usercommissionrole, notice: 'Usercommissionrole was successfully created.' }
        format.json { render :show, status: :created, location: @usercommissionrole }
      else
        format.html { render :new }
        format.json { render json: @usercommissionrole.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /usercommissionroles/1
  # PATCH/PUT /usercommissionroles/1.json
  def update
    respond_to do |format|
      if @usercommissionrole.update(usercommissionrole_params)
        format.html { redirect_to @usercommissionrole, notice: 'Usercommissionrole was successfully updated.' }
        format.json { render :show, status: :ok, location: @usercommissionrole }
      else
        format.html { render :edit }
        format.json { render json: @usercommissionrole.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /usercommissionroles/1
  # DELETE /usercommissionroles/1.json
  def destroy
    @usercommissionrole.destroy
    respond_to do |format|
      format.html { redirect_to usercommissionroles_url, notice: 'Usercommissionrole was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_usercommissionrole
      @roleOpts = nil
      @usercommissionrole = Usercommissionrole.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def usercommissionrole_params
      params.require(:usercommissionrole).permit(:role_id, :user_id, :commission_id,:radio_selected)
    end
end
