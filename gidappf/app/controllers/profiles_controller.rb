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
    User.find_by(email: LockEmail::LIST[1]).documents.each do |d|
      @profiles -= @profiles.where(id: d.profile_id)
    end
  end

  # GET /profiles/1
  # GET /profiles/1.json
  def show
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
        purge_profile_keys(@profile)
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

  #########################################################################################
  # Prerequisitos:                                                                        #
  #           1) Modelo de datos inicializado.                                            #
  #           2)Asociacion un User a muchos Usercommisssionrole registrada en el modelo.  #
  #           3) Role con level 10 y enabled false existente.                             #
  # Devolución: Registro de un nuevo usuario con password provisorio y rol de ingresante. #
  #             Redirecciona a la accion second con los parametros id_user y user_dni.    #
  #########################################################################################
  def first
    @user = User.new({email: (User.last.id+1).to_s+'@gidappf.edu.ar'})
    unless params[:dni_profile].nil? || params[:email_profile].nil? then
      if User.find_by(email: params[:email_profile]).nil? then
        @user = User.new({email: params[:email_profile], password: params[:dni_profile], password_confirmation: params[:dni_profile]})
        if @user.save && Usercommissionrole.new( #Si crea al ussuario, crea el registro en Usercommissionrole
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

  #########################################################################################
  # Prerequisitos:                                                                        #
  #           1) Modelo de datos inicializado.                                            #
  #           2) Asociacion un User a muchos Documents registrada en el modelo.           #
  #           3) Asociacion un Profile a muchos Documents registrada en el modelo.        #
  #           4) Asociacion un Profile a muchos ProfileKey registrada en el modelo.       #
  #           5) Asociacion un ProfileKey a muchos ProfileValue registrada en el modelo.  #
  #           6) Existencia de la plantilla del perfil en Profile.firts.                  #
  # Devolución: Registro de un nuevo perfil asociado al usuario con el id_user recuperado #
  #             por params. Las claves (ProfileKey) del perfil se copian de la plantilla. #
  #########################################################################################
  # GET /profiles/second
  def second
    unless params[:id_user].nil? || params[:user_dni].nil? then
      u = User.find(params[:id_user].to_i)
      unless u.nil? then
        @p=Profile.find_by( name: params[:user_dni])
        if @p.nil? then #crea perfil si no tiene
          @p=Profile.new( name: params[:user_dni], description: make_description(u.email), valid_from: Date.today, valid_to: 1.year.after )
          if @p.save && Document.new(profile: Profile.last, user: u).save then
            if @p.profile_keys.empty? then #copia claves del perfil si no tiene
              User.find_by(email: LockEmail::LIST[1]).documents.first.profile.profile_keys.each do |k|
                ProfileKey.new(profile: @p, key: k.key).save
                unless k.key.eql?(User.find_by(email: LockEmail::LIST[1]).documents.first.profile.profile_keys.find(3).key) then
                  ProfileValue.new(profile_key: ProfileKey.last).save
                else #copia el valor del dni si ess la clave 3 de la plantilla
                  ProfileValue.new(profile_key: ProfileKey.last, value: params[:user_dni]).save
                end
              end
            end
          end
        end
        redirect_to edit_profile_path(@p) #redirige al rellenado de valores
      else
        redirect_back fallback_location: '/profiles', allow_other_host: false, alert: 'Not User identification found!'
      end
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

    #########################################################################################
    # Prerequisitos:                                                                        #
    #           1) Modelo de datos inicializado.                                            #
    #           2) Asociacion un Profile a muchos ProfileKey registrada en el modelo.       #
    #           3) Asociacion un ProfileKey a muchos ProfileValue registrada en el modelo.  #
    #           4) Existencia de la plantilla del perfil en Profile.firts.                  #
    # Devolución: Perfil asociado a las claves mas recientes. desscarta las obsoletas.      #
    #########################################################################################
    def purge_profile_keys(profile)
      if profile.profile_keys.count > Profile.first.profile_keys.count then
        profile.profile_keys.each do |eachkey|
          if (Time.now - Time.parse(eachkey.created_at.to_s)) > 6 then
            eachkey.destroy
          end
        end
      end
    end

    #########################################################################################
    # Prerequisitos:                                                                        #
    #           1) Modelo de datos inicializado.                                            #
    #           2) Asociacion un User a muchos Usercommisssionrole registrada en el modelo. #
    #           3) Asociacion un Role a muchos Usercommisssionrole registrada en el modelo. #
    #           4) Existencia del email en el registro de usuarios.                         #
    # Devolución: Valor editable del campo descripcion.                                     #
    #########################################################################################
    def make_description(email)
      "Legajo= #{Profile.count+1}, email principal: #{email}. Estado: #{User.find_by(email: email).usercommissionroles.first.role.name}."
    end
end
