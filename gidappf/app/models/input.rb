require 'gidappf_templates_tools'

class Input < ApplicationRecord
  ##########################account#####################################
  # Asociación uno a muchos: soporta que un input sea asignado muchas  #
  #                          veces en distintos documents.             #
  #                          Si se borra, lo hacen documents.          #
  ######################################################################
  has_many :documents, dependent: :destroy

  ##########################account#####################################
  # Asociación uno a muchos: soporta que un input sea asignado muchas  #
  #                          veces en distintos info_keys.             #
  #                          Si se borra, anula info_keys.             #
  ######################################################################
  has_many :info_keys, dependent: :destroy

  ##########################account#####################################
  # Configuracion dependencia de atributos:                            #
  #        Los atributos de Input dependen de Info_keys.               #
  ######################################################################
  accepts_nested_attributes_for :info_keys

  ###################################################################################
  # Prerequisitos:                                                                  #
  #           1) Modelo de datos inicializado.                                      #
  #           2) Asociacion un User a muchos Documents registrada en el modelo.     #
  #           3) Asociacion un Input a muchos Documents registrada en el modelo.    #
  #           4) Asociacion un Input a muchos InfoKey registrada en el modelo.      #
  #           5) Asociacion un InfoKey a muchos InfoValue registrada en el modelo.  #
  #           6) Existencia de la plantilla del perfil en Input.find(template).     #
  # Devolución: Las claves (InfoKey) de la plantilla input se copian en este Input. #
  ###################################################################################
  # def copy_template(template)
  #   if self.info_keys.empty? then #copia claves si no tiene
  #     Input.find(template).info_keys.each do |i|
  #       self.info_keys.build(:key => i.key, :client_side_validator_id => i.client_side_validator_id).info_values.build(:value => nil).save
  #     end
  #   end
  # end

  #########################################################################################
  # Método privado: implementa inicialización de la variable estática @@template.         #
  # Prerequisitos:                                                                        #
  #           1) Modelo de datos inicializado.                                            #
  #           2) Asociacion un Profile a muchos ProfileKey registrada en el modelo.       #
  #           3) Asociacion un ProfileKey a muchos ProfileValue registrada en el modelo.  #
  #           4) Existencia del arreglo estático LockEmail::LIST.                         #
  # Devolución: Rol para asociarlo al nuevo perfil.                                       #
  #########################################################################################
    def template_to_merge
      out=Input.find_by(title: 'Administrative rules').id
      t1=self.info_keys.pluck(:key)#array de info_keys
      templates=get_templates(Input.all)
      templates.each do |t|
        if GidappfTemplatesTools.compare_templates_do(t1, InfoKey.where(input: t).pluck(:key)) then
          out = t.id
        end
      end
      out
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
      inputs.where(id: InfoKey.where.not(id: InfoValue.pluck(:info_key_id)).pluck(:input_id).uniq)
    end

  ##################################################################################
  # Implementa merge para info_key del @input seleccionado.                        #
  # Prerequisitos:                                                                 #
  #           1) Modelo de datos inicializado.                                     #
  #           2) Asociacion un Input a muchos InfoKey registrada en el modelo.     #
  #           3) Asociacion un InfoKey a muchos InfoValue registrada en el modelo. #
  #           4) Existencia del arreglo estático LockEmail::LIST.                  #
  #           5) Existencia de la variable de clase @@template inicializada.       #
  # Devolución: mantiene los elementos de info_keys equivalente al de @@templale.  #
  ##################################################################################
    def merge_each_key(template)
      in1=Input.find(template)
      if !self.grouping.eql?(in1.grouping?) then self.update(grouping: in1.grouping?) end
      in1.info_keys.each do |tik|
        if self.info_keys.where(key: tik.key).count == 2 then
          keys=self.info_keys.where(key: tik.key)
          max=keys.find_by(key: tik.key,created_at: keys.maximum('created_at'))
          min=keys.find_by(key: tik.key,created_at: keys.minimum('created_at'))
          read_only_or_link=ClientSideValidator.where(content_type: "GIDAPPF links").
            or(ClientSideValidator.where(content_type: "GIDAPPF read only")).include?(min.client_side_validator)
          if max.client_side_validator_id.nil? && !read_only_or_link then
            max.update(client_side_validator_id: min.client_side_validator_id)
            min.destroy
          elsif read_only_or_link then
            max.destroy
          end
        end
      end
    end

  ##################################################################################
  # Implementa sincronismmo con vacantes.                                          #
  # Prerequisitos:                                                                 #
  #           1) Modelo de datos inicializado.                                     #
  #           2) Asociacion un Input a muchos InfoKey registrada en el modelo.     #
  #           3) Asociacion un InfoKey a muchos InfoValue registrada en el modelo. #
  # Devolución: mantiene un único set de info_value actualizado por cada info_key. #
  ##################################################################################
    def present_each_vacancy
      if self.title.eql?('Time sheet hour students list') && self.grouping? then
        ungrouping_each_student_list.each do |u|
          if u[0].upcase.eql?('Si'.upcase) then
            pres = Vacancy.find(u[1].to_i)
            pres.occupant = u[2].to_i
            pres.save
          end
        end
      end
    end

private

  def ungrouping_each_student_list
    hash=[]
    it_pr=self.info_keys.find_by(key: "Presente:").info_values.to_enum
    it_vac=self.info_keys.find_by(key: "Vacante:").info_values.to_enum
    self.info_keys.find_by(key: "Legajo:").info_values.each do |l|
      hash << [ it_pr.next.value.dup, it_vac.next.value.dup, l.value.dup.gsub(/[^0-9]/, '') ]
    end
    hash
  end

end
