module GidappfTemplatesTools
#######################################################################################
# Implementa comparación entre arrays para saber si todos los elementos de list están #
# en reference.                                                                       #
# Prerequisitos:                                                                      #
#           1) reference not null.                                                    #
# Devolución: True si cada elemento de list está en reference.                        #
########################################################################################
  def self.compare_templates_do(list, reference)
    out = list.count >= reference.count
    if out then
      list.each do |e|
        unless reference.include?(e) then out=false end
      end
    end
    out
  end

######################################################################################
# Implementa la creacion de ActiveJobs para cada lista de estudiantes en su horario. #
# en reference.                                                                      #
# Prerequisitos:                                                                     #
#           1) time_sheet_hour sin componentes ActiveJobs.                           #
# Devolución: ActiveJobs creados para generar documentos Time sheet hour students    #
# list para cada inicio de clase del horario.                                        #
######################################################################################
  def self.students_list_to_circulate_at_hour(time_sheet_hour)
    "The student list will not be circulated id:#{time_sheet_hour.id}"
  end

end #module
