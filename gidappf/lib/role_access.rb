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
# Archivo GIDAPPF/gidappf/lib/role_access.rb                              #
###########################################################################
module RoleAccess

  #####################################################################################################################
  # Prerequisitos:                                                                                                     #
  #           1) Modelo de datos inicializado                                                                          #
  # Devolución: 40 si el usercommisionrole relaciona a @user en alguna de sus comisiones con el rol 4 al menos una vez #
  #             30 si el usercommisionrole relaciona a @user en alguna de sus comisiones con el rol 3 al menos una vez #
  #             20 si el usercommisionrole relaciona a @user en alguna de sus comisiones con el rol 2 al menos una vez #
  #             10 si el usercommisionrole relaciona a @user en alguna de sus comisiones con el rol 3 al menos una vez #
  #             -10 si el usercommisionrole no relaciona a @user en ninguna comision                                   #
  ######################################################################################################################
  def self.get_role_access(current_user)
    roleaccess=-10.0
    l= Usercommissionrole.where(user: current_user.id).joins(:role).
        select(:level).maximum("level")
    unless l.nil? then
      roleaccess=l
    end #unless
    roleaccess
  end #method

  ##########################################################################################################################################
  # Prerequisitos:                                                                                                                         #
  #           1) Modelo de datos inicializado                                                                                              #
  # Devolución: 'layouts/forty_links' si el usercommisionrole relaciona a @user en alguna de sus comisiones con el rol 4 al menos una vez  #
  #             'layouts/thirty_links' si el usercommisionrole relaciona a @user en alguna de sus comisiones con el rol 3 al menos una vez #
  #             'layouts/twenty_links' si el usercommisionrole relaciona a @user en alguna de sus comisiones con el rol 2 al menos una vez #
  #             'layouts/ten_links' si el usercommisionrole relaciona a @user en alguna de sus comisiones con el rol 3 al menos una vez    #
  #             'layouts/links_logout' si el usercommisionrole no relaciona a @user en ninguna comision                                    #
  ##########################################################################################################################################
  def self.get_user_links(current_user)
    out=''
    unless current_user.nil? then
      l=self.get_role_access(current_user)
      if l >= 40.0 then
        out='layouts/forty_links'
      elsif l < 40.0 && l >= 30.0 then
        out='layouts/thirty_links'
      elsif l < 30.0 && l >= 20.0 then
        out='layouts/twenty_links'
      elsif l < 20.0 && l >= 10.0 then
        out='layouts/ten_links'
      elsif l < 10.0 && l >= -10.0 then
        out='layouts/links_logout'
      end
    else
      out='layouts/links_logout'
    end
    out
  end

  def self.get_inputs_emails(current_user)
    acc = self.get_role_access(current_user)
    out=LockEmail::LIST.dup
    if acc < 40 && acc >= 29
      out.shift 2
    elsif acc < 29 && acc >= 20
      out.shift 3
    elsif acc < 20 && acc >= 10
      out.shift 4
    elsif acc < 10 && acc >= -20
      out.shift 5
    end
    out
  end

end #module
