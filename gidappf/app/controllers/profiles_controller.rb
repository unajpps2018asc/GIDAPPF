require 'role_access'
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
# Archivo GIDAPPF/gidappf/app/controllers/profiles_controller.rb          #
###########################################################################
class ProfilesController < ApplicationController
  include RoleAccess
  before_action :set_profile, only: [:show, :edit, :update, :destroy]

  # GET /profiles
  # GET /profiles.json
  def index
    @profiles = Profile.all
    authorize @profiles
  end

  # GET /profiles/1
  # GET /profiles/1.json
  def show
  end

  # GET /profiles/new
  def new
    @profile = Profile.new
    @profile.profile_keys.build.profile_values.build
    respond_to do |format|
      format.html { }
      format.json { head :no_content }
    end
  end

  # GET /profiles/1/edit
  def edit
    respond_to do |format|
      format.html { }
      format.json { head :no_content }
    end
  end

  # POST /profiles
  # POST /profiles.json
  def create
    @profile = Profile.new(profile_params)
    authorize @profile #inicialización del nivel de acceso
    respond_to do |format|
      if @profile.save
        format.html { redirect_to @profile, notice: 'Profile was successfully created.' }
        format.json { render :show, status: :created, location: @profile }
      else
        format.html { render :new }
        format.json { render json: @profile.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /profiles/1
  # PATCH/PUT /profiles/1.json
  def update
    respond_to do |format|
      if @profile.update(profile_params)
        format.html { redirect_to @profile, notice: 'Profile was successfully updated.' }
        format.json { render :show, status: :ok, location: @profile }
      else
        format.html { render :edit }
        format.json { render json: @profile.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /profiles/1
  # DELETE /profiles/1.json
  def destroy
    @profile.destroy
    respond_to do |format|
      format.html { redirect_to profiles_url, notice: 'Profile was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # GET /profiles/first
  def first
    @user = User.new({email: (User.last.id+1).to_s+'@gidappf.edu.ar'})
    unless params[:dni_profile].nil? || params[:email_profile].nil? then
      if User.find_by(email: params[:email_profile]).nil? then
        @user = User.new({email: params[:email_profile], password: params[:dni_profile], password_confirmation: params[:dni_profile]})
        if @user.save && Usercommissionrole.new(
            role_id: Role.find_by(level: 10, enabled: false).id,
            user_id: @user.id, commission_id: Commission.first.id
          ).save then
          respond_to do |format|
            msg = "User created id=#{@user.id} role=#{@user.usercommissionroles.first.role.name}"
            format.html { redirect_to profiles_second_path(id_user: @user.id.to_s, user_dni: params[:dni_profile]), notice: msg }
            format.json { render :second, status: :ok}
          end
        end
      else
        redirect_back fallback_location: '/profiles', allow_other_host: false, alert: 'Email is allready registred.'
      end
    end
  end

  # GET /profiles/second
  def second
    unless params[:id_user].nil? || params[:user_dni].nil? then
      @p=Profile.find_by( name: params[:user_dni])
    #   if @p.nil? then
    #     u = User.find(params[:id_user].to_i)
    #     @p=Profile.new( name: params[:user_dni], description: u.email, valid_from: Date.today, valid_to: 1.year.after )
    #     @p.save
    #     Document.new(profile: Profile.last, user: u).save
    #   end
    #   if @p.profile_key.empty?
    #     User.find_by(email: 'student@gidappf.edu.ar').document.first.profile.profile_key.each do |k|
    #       ProfileKey.new(profile: @p, key: k.key).save
    #       unless k.key.eql?('D.N.I.:') then
    #         ProfileValue.new(profile_key: ProfileKey.last).save
    #       else
    #         ProfileValue.new(profile_key: ProfileKey.last, value: params[:user_dni]).save
    #       end
    #     end
    #     # params[:profile]
    #   end
    #   if finish_second(@p) then
        respond_to do |format|
          msg = 'Profile created Nr: '+ Profile.last.id.to_s+ 'Elements: '+ Profile.last.profile_keys.count.to_s
          format.html { redirect_to profiles_path, notice: msg }
          format.json { render :second, status: :ok}
        end
      # end
    else
      redirect_back fallback_location: '/profiles', allow_other_host: false, alert: 'Not User identification found!'
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_profile
      @profile = Profile.find(params[:id])
      authorize @profile #inicialización del nivel de acceso
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def profile_params
      params.require(:profile).permit(:name, :description, :valid_to, :valid_from,
        :profile_keys_attributes => [
          :key,
          :profile_values_attributes => [:value]
        ]
      )
    end

    # def finish_second(profile)
    #   u=profile.last.document.first.user
    #   out=false
    #   profile.profile_key.each do |v|
    #     out &= v.profile_value.update(value: "12")
    #   end
    #   out
    # end
end
