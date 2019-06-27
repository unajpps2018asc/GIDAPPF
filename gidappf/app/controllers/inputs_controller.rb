class InputsController < ApplicationController
  before_action :set_input, only: [:show, :edit, :update, :destroy, :disable]
  after_action :merge_info_keys, only: [:update]

  # GET /inputs
  # GET /inputs.json
  def index
    @ins=RoleAccess.get_inputs_emails(current_user) # module RoleAccess
    @ins << current_user.email
    @inputs = get_not_templates(Input.all).where(id: Document.where(user: User.where(email: @ins)).pluck(:input_id))
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
        format.html { redirect_to @input, notice: 'Input was successfully created.' }
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
        format.html { redirect_to @input, notice: 'Input was successfully updated.' }
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
      format.html { redirect_to inputs_url, notice: 'Input was successfully destroyed.' }
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

end
