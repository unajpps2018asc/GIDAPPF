class InputsController < ApplicationController
  before_action :set_input, only: [:show, :edit, :update, :destroy, :disable]
  after_action :merge_info_keys, only: [:update]

  # GET /inputs
  # GET /inputs.json
  def index
    @inputs = get_not_templates(Input.all).where(id: Document.where(user: User.where(email: RoleAccess.get_inputs_emails(current_user))).pluck(:input_id))
    @templates = get_templates(Input.all)
    authorize @inputs
  end

  # GET /inputs/1
  # GET /inputs/1.json
  def show
    authorize Input.first
  end

  # GET /inputs/new
  def new
    @input = Input.new
    authorize @input
    respond_to do |format|
      format.html { }
      format.json { head :no_content }
    end
  end

  # GET /inputs/1/edit
  def edit
    respond_to do |format|
      format.html { }
      format.json { head :no_content }
    end
  end

  # POST /inputs
  # POST /inputs.json
  def create
    @input = Input.new(input_params)
    authorize @input
    respond_to do |format|
      if @input.save
        format.html { redirect_to @input, notice: t('body.gidappf_entity.input.action.new.notice') }
        format.json { render :show, status: :created, location: @input }
      else
        format.html { render :new }
        format.json { render json: @input.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /inputs/1
  # PATCH/PUT /inputs/1.json
  def update
    respond_to do |format|
      if @input.update(input_params)
        format.html { redirect_to @input, notice: t('body.gidappf_entity.input.action.update.notice') }
        format.json { render :show, status: :ok, location: @input }
      else
        format.html { render :edit }
        format.json { render json: @input.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /inputs/1
  # DELETE /inputs/1.json
  def destroy
    @input.destroy
    respond_to do |format|
      format.html { redirect_to inputs_url, notice: t('body.gidappf_entity.input.action.destroy.notice') }
      format.json { head :no_content }
    end
  end

  # PATCH /inputs/1
  # PATCH /inputs/1.json
  def disable
    @input.update(enable: false)
    respond_to do |format|
      format.html { redirect_to inputs_url, notice: 'Input was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def commission_qualification_list_students
    time_sheet_hour=TimeSheetHour.find(params[:tsh_id].to_i)
    authorize time_sheet_hour
    if RoleAccess.get_inputs_emails(current_user).include?("docent@gidappf.edu.ar") &&
      !params[:tsh_id].to_i.nil? && !current_user.documents.first.nil? then
      docent_profile=current_user.documents.first.profile
      @input=new_calification_student_list(time_sheet_hour,docent_profile)
      #Legajo:t[0] Nota:t[1] Nota docente:t[2] Acta:t[3] Comentario:t[4]
      t=keys_calification_student_list('DocentProfile','Calification student list','docent@gidappf.edu.ar')
      leg=@input.info_keys.build(:key => t[0].key,
        :client_side_validator_id => t[0].client_side_validator_id)
      cali=@input.info_keys.build(:key => t[1].key,
        :client_side_validator_id => t[1].client_side_validator_id)
      conc=@input.info_keys.build(:key => t[2].key,
        :client_side_validator_id => t[2].client_side_validator_id)
      act=@input.info_keys.build(:key => t[3].key,
        :client_side_validator_id => t[3].client_side_validator_id)
      obs=@input.info_keys.build(:key => t[4].key,
        :client_side_validator_id => t[4].client_side_validator_id)
      Profile.where(id: Document.where(user_id: User.where(id: time_sheet_hour.
        time_sheet.commission.usercommissionroles.pluck(:user_id))).distinct(:user_id).
        pluck(:profile_id)).where('valid_from <= ?', Date.today).where('valid_to >= ?', Date.today).
        where.not(id: current_user.documents.pluck(:profile_id)).each do |p|
        if p.listable? then
          c = make_student_calification(p, time_sheet_hour, docent_profile)
          leg.info_values.build(:value => p.to_global_id )
          cali.info_values.build(:value => " " )
          conc.info_values.build(:value => " " )
          act.info_values.build(:value => c.to_global_id )
          obs.info_values.build(:value => " " )
        end
      end
      @input.save
      Document.new(profile: docent_profile, user: current_user, input: @input).save
    elsif current_user.documents.first.nil? then
      redirect_back fallback_location: root_path, allow_other_host: false, alert: 'Please, generate profile before...'
    end
  end

  # def commission_qualification_averanges
  # end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_input
      @input = Input.find(params[:id])
      authorize @input
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def input_params
      params.require(:input).permit(:title, :summary, :grouping, :enable, :author,
        :info_keys_attributes => [:key, :client_side_validator_id,
          :info_values_attributes => [:value]
          ])
    end

  #####################################################################################
  # Método privado: implementa filtrado de plantillas que separa a los documentos.    #
  # Prerequisitos:                                                                    #
  #           1) Modelo de datos inicializado.                                        #
  #           2) Asociacion un Informmation a muchos InfoKey registrada en el modelo. #
  #           3) Asociacion un InfoKey a muchos InfoValue registrada en el modelo.    #
  # Devolución: ActiveQuery con todos los docummentos no vacios.                      #
  #####################################################################################
    def get_not_templates(inputs)
      out = nil
      if RoleAccess.get_role_access(current_user) < 30
        out = inputs.where.not(enable: false)
      else
        out = inputs
      end
      out=out.where(
        id: InfoKey.where(id: InfoValue.pluck(:info_key_id)
        ).pluck(:input_id).uniq
      )
      out
    end

  #####################################################################################
  # Método privado: implementa filtrado de documentos que separa a las plantillas.    #
  # Prerequisitos:                                                                    #
  #           1) Modelo de datos inicializado.                                        #
  #           2) Asociacion un Input a muchos InfoKey registrada en el modelo.        #
  #           3) Asociacion un InfoKey a muchos InfoValue registrada en el modelo.    #
  # Devolución: ActiveQuery con todos los docummentos vacios.                         #
  #####################################################################################
    def get_templates(inputs)
      out=inputs.where(
        id: (InfoKey.all-InfoKey.where(id: InfoValue.pluck(:info_key_id))).pluck(:input_id).uniq
      )
      out
    end

  #################################################################################
  # Método privado: implementa estrategia de edición de nested atributos.         #
  # Prerequisitos:                                                                #
  #           1) Modelo de datos inicializado.                                    #
  #           2) Asociacion un Input a muchos InfoKey registrada en el modelo.    #
  #           3) Asociacion un InfoKey a muchos InfoValue registrada en el modelo.#
  #           4) Existencia del arreglo estático LockEmail::LIST.                 #
  # Devolución: Input seleccionado en @input asociado a las claves mas recientes. #
  #             Descarta valores no inicializados.                                #
  #################################################################################
    def merge_info_keys
      @@template=@input.template_to_merge
      @input.merge_each_key(@@template)
      if @input.title.eql?('Time sheet hour students list') then
        @input.present_each_vacancy
      elsif @input.title.eql?('Calification student list') then
        @input.calif_each_act
      end
      sync_slaves
    end

    def sync_slaves
      master=Document.where(
        input_id: Input.where(title: @input.title).ids,
        user_id: User.where(email: LockEmail::LIST).ids
      ).first
      if master.eql?(@input.documents.first) &&
        !InfoValue.where(info_key_id: @input.info_keys.ids).empty? then
        unless master.update_in_all then
          flash[:errors]="Not Synchronized"
        end
      end
    end

  ##############################################################################
  # Método privado: genera un nuevo input para 'Calification student list'     #
  #           1) Modelo de datos inicializado.                                 #
  #           2) Asociacion un Input a muchos InfoKey registrada en el modelo. #
  # Devolución: Nuevo input 'Calification student list'                        #
  ##############################################################################
    def new_calification_student_list(time_sheet_hour,docent_profile)
      Input.new( title: 'Calification student list',
        summary: "Materia:#{time_sheet_hour.matter.name}, fecha: #{
        time_sheet_hour.created_at}, aula: #{time_sheet_hour.vacancy.
        class_room_institute.name}.", grouping: true, enable: true,
        author: docent_profile.id)
    end

  ################################################################################
  # Método privado: patron ActiveRecord relation para 'Calification student list'#
  #           1) Modelo de datos inicializado.                                   #
  #           2) Asociacion un Input a muchos InfoKey registrada en el modelo.   #
  # Devolución: Nuevo ActiveRecord relation para 'Calification student list'     #
  ################################################################################
    def keys_calification_student_list(name,title,email)
      Document.find_by(profile: Profile.find_by( name: name),
        input: Input.find_by(title: title), user: User.find_by(email: email)
      ).input.info_keys
    end

  ################################################################################
  # Método privado: patron ActiveRecord relation para 'Calification student list'#
  #           1) Modelo de datos inicializado.                                   #
  #           2) Asociacion un Input a muchos InfoKey registrada en el modelo.   #
  # Devolución: Document 'Calification student list'                             #
  ################################################################################
    def make_student_calification(profile, time_sheet_hour, author)
      out=nil
      u=profile.documents.first.user
      template=Input.where(title: 'Student calification').first
      calification=Input.new( title: template.title, summary:
        "#{template.summary} para: #{profile.name}, materia:#{time_sheet_hour.matter.name}.",
        grouping: template.grouping, enable: true, author: author.id )
      template.info_keys.each do |t|
        calif_key = calification.info_keys.build(:key => t.key,
          :client_side_validator_id => t.client_side_validator_id)
        if t.key.eql?('Legajo:') then
          calif_key.info_values.build(:value => profile.id)
        end
        if t.key.eql?('Nombre y apellido:') then
          val = " "
          unless profile.profile_keys.find_by(key: Profile.first.profile_keys.find(1).key).profile_values.first.value.nil? then
            val << profile.profile_keys.find_by(key: Profile.first.profile_keys.find(1).key).profile_values.first.value
          end
          val << " "
          unless profile.profile_keys.find_by(key: Profile.first.profile_keys.find(2).key).profile_values.first.value.nil? then
            val << profile.profile_keys.find_by(key: Profile.first.profile_keys.find(2).key).profile_values.first.value
          end
          calif_key.info_values.build(:value => val)
        end
        if t.key.eql?('Calificación:') then
          calif_key.info_values.build(:value => " ")
        end
        if t.key.eql?('Observaciones:') then
          calif_key.info_values.build(:value => " ")
        end
        calif_key.save
      end
      calification.save
      out=Document.new(
        profile_id: u.documents.first.profile_id,
        user_id: u.id,
        input_id: calification.id
      )
      out.save
      out.input
    end

end
