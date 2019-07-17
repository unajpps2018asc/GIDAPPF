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
      out=Input.where(title: 'Administrative rules').minimum('id')
      if out != self.id then
        t1=self.info_keys.pluck(:key)#array de info_keys
        templates=get_templates(Input.all)
        templates.each do |t|
          if GidappfTemplatesTools.compare_templates_do(t1, InfoKey.where(input: t).pluck(:key)) then
            out = t.id
          end
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
  #           6) Parametro template es un string numerico con el id del Input.     #
  # Devolución: mantiene los elementos de info_keys equivalente al de templale.    #
  ##################################################################################
    def merge_each_key(template)
      in1=Input.find(template.to_i)
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
        #Legajos:t[0] 	Vacantes:t[1] 	Presente:t[2]
        rows_present_vacancy_profile_id_to_arr.each do |pre_vac_pro|
          if pre_vac_pro[0].upcase.eql?('Si'.upcase) then
            vacancy = Vacancy.find(pre_vac_pro[1].to_i)
            vacancy.occupant = pre_vac_pro[2].to_i
            vacancy.save
          end
        end
      end
    end

  ##################################################################################
  # Implementa sincronismo con notas de cada acta de estudiante.                   #
  # Prerequisitos:                                                                 #
  #           1) Modelo de datos inicializado.                                     #
  #           2) Asociacion un Input a muchos InfoKey registrada en el modelo.     #
  #           3) Asociacion un InfoKey a muchos InfoValue registrada en el modelo. #
  # Devolución: mantiene un único set de info_value actualizado por cada info_key. #
  ##################################################################################
    def calif_each_act
      if self.title.eql?('Calification student list') && self.grouping? then
        #Legajo:t[0] Nota:t[1] Nota docente:t[2] Acta:t[3] Comentario:t[4]
        rows_profile_id_note_note_docent_act_comment_to_arr.each do |pro_note1_note2_act_comm|
          act_calif=Input.find(pro_note1_note2_act_comm[3].to_i) #title: 'Student calification'
          if !act_calif.nil? && pro_note1_note2_act_comm[0].eql?(
            act_calif.info_keys.find_by(key: 'Legajo:').info_values.first.value) then
            act_calif.info_keys.find_by(key: 'Calificación:').info_values.first.
              update(value: pro_note1_note2_act_comm[1])
            act_calif.info_keys.find_by(key: 'Observaciones:').info_values.first.
              update(value: pro_note1_note2_act_comm[4])
          end
          act_calif.update(summary: "Reporte de calificaciones individual. "+self.summary)
        end
      end
    end

private

  def rows_profile_id_note_note_docent_act_comment_to_arr
    rows=[]
    it_profile=self.info_keys.find_by(key: "Legajo:").info_values.to_enum
    it_calif1=self.info_keys.find_by(key: "Nota:").info_values.to_enum
    it_calif2=self.info_keys.find_by(key: "Nota docente:").info_values.to_enum
    it_comm=self.info_keys.find_by(key: "Comentario:").info_values.to_enum
    self.info_keys.find_by(key: "Acta:").info_values.each do |a|
      rows << [ it_profile.next.value.dup.gsub(/[^0-9]/, ''),#0
                it_calif1.next.value.dup,#1
                it_calif2.next.value.dup,#2
                a.value.dup.gsub(/[^0-9]/, ''),#3
                it_comm.next.value.dup ]#4
    end
    rows
  end

  def rows_present_vacancy_profile_id_to_arr
    rows=[]
    it_pr=self.info_keys.find_by(key: "Presente:").info_values.to_enum
    it_vac=self.info_keys.find_by(key: "Vacante:").info_values.to_enum
    self.info_keys.find_by(key: "Legajo:").info_values.each do |l|
      rows << [ it_pr.next.value.dup, it_vac.next.value.dup, l.value.dup.gsub(/[^0-9]/, '') ]
    end
    rows
  end

end
