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
  before_action :set_profile, only: [:show, :edit, :update, :destroy]

  # GET /profiles/new
  #Profile.new(valid_from: Date.today, valid_to: 1.year.after ).profile_keys.build(:key => ProfileKey.first.key, :client_side_validator_id => ProfileKey.first.client_side_validator_id).profile_values.build(:value => 'x').save
  def new
    authorize Profile.first
    @profile = Profile.new(valid_from: Date.today, valid_to: 1.year.after )
    User.find_by(email: params[:pointer]).documents.first.profile.profile_keys.each do |i|
      @profile.profile_keys.build(:key => i.key, :client_side_validator_id => i.client_side_validator_id).profile_values.build(:value => nil).save
    end
    respond_to do |format|
      format.html { }
      format.json { head :no_content }
    end
  end

  # GET /profiles
  # GET /profiles.json
  def index
    @profiles = Profile.where('id > ?',LockEmail::LIST.count-1)
    unless params[:role_ids].nil?
      rids = []
      params[:role_ids].each do |i| rids.push(i.to_i) end
      @profiles = Profile.where(
        :id => Document.where(
          :user_id => Usercommissionrole.where(
            :role_id => rids).pluck(:user_id)
          ).pluck(:profile_id)
        )
    end
    authorize @profiles
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
      if @profile.save then
        format.html { redirect_to @profile, notice: t('body.gidappf_entity.profile.action.new.notice') }
        format.json { render :show, status: :created, location: @profile }
      else
        format.html { render new_profile_path }
        format.json { render json: @profile.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /profiles/1
  # PATCH/PUT /profiles/1.json
  def update
    respond_to do |format|
      if @profile.update(profile_params)
        merge_profile_keys
        format.html { redirect_to @profile, notice: t('body.gidappf_entity.profile.action.update.notice') }
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
      format.html { redirect_to profiles_url, notice: t('body.gidappf_entity.profile.action.destroy.notice') }
      format.json { head :no_content }
    end
  end

  #########################################################################################
  # Prerequisitos:                                                                        #
  #           1) Modelo de datos inicializado.                                            #
  #           2)Asociacion un User a muchos Usercommisssionrole registrada en el modelo.  #
  #           3) Role con level 10 y enabled false existente.                             #
  #           4) Primer comisión de ingresantes existente.                                #
  # Devolución: Registro de un nuevo usuario con password provisorio y rol de ingresante. #
  #             Redirecciona a la accion second con los parametros id_user y user_dni.    #
  #########################################################################################
  def first
    authorize Profile.first
    @@template=params[:pointer]
    @user = User.new({email: (User.last.id+1).to_s+'@gidappf.edu.ar'})
    unless params[:dni_profile].nil? || params[:email_profile].nil? then
      used = ProfileValue.find_by(value: params[:dni_profile].to_s)
      if User.find_by(email: params[:email_profile]).nil? && (used.nil? || !used.profile_key.key.eql?(Profile.first.profile_keys.find(3).key)) then
        @user = User.new({email: params[:email_profile], password: params[:dni_profile], password_confirmation: params[:dni_profile]})
        if @user.save && Usercommissionrole.new( #Si crea al usuario, crea el registro en Usercommissionrole
            role_id: first_role_from_pointer,user_id: @user.id, commission_id: Commission.first.id
          ).save then
          if @@template.eql?(LockEmail::LIST[3])then
            2.times do |i|
              Usercommissionrole.new( role_id: first_role_from_pointer,user_id: @user.id, commission_id: Commission.first.id).save
            end
          end
          respond_to do |format|
            msg = "#{t('body.gidappf_entity.profile.action.first.msg1')}#{@user.id}#{t('body.gidappf_entity.profile.action.first.msg2')}#{@user.usercommissionroles.first.role.name}"
            format.html { redirect_to profiles_second_path(id_user: @user.id.to_s, user_dni: params[:dni_profile]), notice: msg }
            format.json { render :second, status: :ok}
          end
        end
      else
        redirect_back fallback_location: '/profiles', allow_other_host: false,
        alert: "#{t('body.gidappf_entity.profile.action.first.msg3')} #{User.find_by(email: LockEmail::LIST[4]).documents.first.profile.profile_keys.find(3).key} #{t('body.gidappf_entity.profile.action.first.msg4')}"
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
    authorize Profile.first
    unless params[:id_user].nil? || params[:user_dni].nil? then
      u = User.find(params[:id_user].to_i)
      unless u.nil? then
        @profile = Profile.find_by( name: params[:user_dni])
        if @profile.nil? then #crea perfil si no tiene
          @profile=Profile.new( name: make_name(params[:user_dni]), description: make_description(u.email), valid_from: Date.today, valid_to: 1.year.after )
          if @profile.save && Input.find_by(title: 'Administrative rules').documents.first.send_copy_first_document_to(@profile,u) then
            #Las claves (ProfileKey) del perfil se copian de la plantilla. #
            @profile.copy_template(@@template,params[:user_dni])
          end
        end
        redirect_to edit_profile_path(@profile) #redirige al rellenado de valores
      else
        redirect_back fallback_location: '/profiles', allow_other_host: false, alert: t('body.gidappf_entity.profile.action.second.alert')
      end
    else
      redirect_back fallback_location: '/profiles', allow_other_host: false, alert: t('body.gidappf_entity.profile.action.second.alert')
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

  def make_name(dni)
    "#{Profile.count+1}/#{dni}"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_profile
      @profile = Profile.find(params[:id])
      authorize @profile #inicialización del nivel de acceso
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def profile_params
      params.require(:profile).permit(:name, :description, :valid_to, :valid_from, #:cover_photo,
        :profile_keys_attributes => [:key, :client_side_validator_id,
          :profile_values_attributes => [:value,:active_stored]
          ])
    end

  ########################################################################################
  # Método privado: implementa estrategia de edición de nested atributos.                #
  # Prerequisitos:                                                                       #
  #           1) Modelo de datos inicializado.                                           #
  #           2) Asociacion un Profile a muchos ProfileKey registrada en el modelo.      #
  #           3) Asociacion un ProfileKey a muchos ProfileValue registrada en el modelo. #
  #           4) Existencia del arreglo estático LockEmail::LIST.                        #
  # Devolución: Perfil seleccionado en @profile asociado a las claves mas recientes.     #
  #             Descarta valores no inicializados.                                       #
  ########################################################################################
    def merge_profile_keys
      @@template=@profile.template_to_merge
      @profile.merge_each_key(@@template)
    end

  #########################################################################################
  # Método privado: implementa inicialización del rol para un nuevoperfil,                #
  # según @@template.                                                                     #
  # Prerequisitos:                                                                        #
  #           1) Modelo de datos inicializado.                                            #
  #           2) Asociacion un Profile a muchos ProfileKey registrada en el modelo.       #
  #           3) Asociacion un ProfileKey a muchos ProfileValue registrada en el modelo.  #
  #           4) Existencia del arreglo estático LockEmail::LIST.                         #
  #           5) Existencia de la variable de clase @@template inicializada.              #
  # Devolución: Rol para asociarlo al nuevo perfil.                                       #
  #########################################################################################
    def first_role_from_pointer
      if LockEmail::LIST[4].eql?(@@template) then
        Role.find_by(level: 10, enabled: false).id
      elsif LockEmail::LIST[3].eql?(@@template) then
        Role.find_by(level: 29, enabled: false).id
      end
    end

end
