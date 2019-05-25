module GidappfTemplatesTools
#########################################################################################
# Método privado: implementa comparación entre arrays para saber si todos los elementos #
#                 de list están en reference.                                           #
# Prerequisitos:                                                                        #
#           1) reference not null.                                                      #
# Devolución: True si cada elemento de list está en reference.                          #
#########################################################################################
  def self.compare_templates_do(list, reference)
    out = list.count >= reference.count
    if out then
      list.each do |e|
        unless reference.include?(e) then out=false end
      end
    end
    out
  end

end #module
