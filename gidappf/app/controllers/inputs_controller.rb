class InputsController < ApplicationController
  before_action :set_input, only: [:show, :edit, :update, :destroy]

  # GET /inputs
  # GET /inputs.json
  def index
    @inputs = get_not_templates(Input.all)
    @templates = get_templates(Input.all)
  end

  # GET /inputs/1
  # GET /inputs/1.json
  def show
  end

  # GET /inputs/new
  def new
    @input = Input.new
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
        merge_info_keys
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_input
      @input = Input.find(params[:id])
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
      inputs.where(
        id: InfoKey.where(
          id: InfoValue.pluck(:info_key_id)
        ).pluck(:input_id).uniq
      )
    end
  #####################################################################################
  # Método privado: implementa filtrado de documentos que separa a las plantillas.    #
  # Prerequisitos:                                                                    #
  #           1) Modelo de datos inicializado.                                        #
  #           2) Asociacion un Informmation a muchos InfoKey registrada en el modelo. #
  #           3) Asociacion un InfoKey a muchos InfoValue registrada en el modelo.    #
  # Devolución: ActiveQuery con todos los docummentos vacios.                         #
  #####################################################################################
    def get_templates(inputs)
      out=inputs.where(
        id: (InfoKey.all-InfoKey.where(id: InfoValue.pluck(:info_key_id))).pluck(:input_id).uniq
      )
      out
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
    def merge_info_keys
      merge_each_value
      @@template=@input.template_to_merge
      merge_each_key
    end

  #########################################################################################
  # Método privado: implementa merge para profile_value de cada profile_key.              #
  # Prerequisitos:                                                                        #
  #           1) Modelo de datos inicializado.                                            #
  #           2) Asociacion un Profile a muchos ProfileKey registrada en el modelo.       #
  #           3) Asociacion un ProfileKey a muchos ProfileValue registrada en el modelo.  #
  # Devolución: mantiene un único profile_value actualizado por cada profile_key.         #
  #########################################################################################
    def merge_each_value
      @input.info_keys.each do |k|
        if k.info_values.count == 2 then
          max=@input.info_keys.find(k.id).info_values.find_by(created_at: k.info_values.maximum('created_at'))
          min=@input.info_keys.find(k.id).info_values.find_by(created_at: k.info_values.minimum('created_at'))
          if max.value.empty? && !min.value.empty? then max.update(value: min.value) end
          min.destroy
        end
      end
    end

  #########################################################################################
  # Método privado: implementa merge para profile_key del @profile seleccionado.          #
  # Prerequisitos:                                                                        #
  #           1) Modelo de datos inicializado.                                            #
  #           2) Asociacion un Profile a muchos ProfileKey registrada en el modelo.       #
  #           3) Asociacion un ProfileKey a muchos ProfileValue registrada en el modelo.  #
  #           4) Existencia del arreglo estático LockEmail::LIST.                         #
  #           5) Existencia de la variable de clase @@template inicializada.              #
  # Devolución: mantiene los elementos de profile_keys equivalente al de @@templale.      #
  #########################################################################################
    def merge_each_key
      Input.find(@@template).info_keys.each do |tik|
        if @input.info_keys.where(key: tik.key).count == 2 then
          keys=@input.info_keys.where(key: tik.key)
          max=keys.find_by(key: tik.key,created_at: keys.maximum('created_at'))
          min=keys.find_by(key: tik.key,created_at: keys.minimum('created_at'))
          if max.client_side_validator_id.nil? then
            max.update(client_side_validator_id: tik.client_side_validator_id)
          end
          if min.info_values.first.gidappf_readonly? then
            max.destroy
          else
            min.destroy
          end
        end
      end
    end

end
