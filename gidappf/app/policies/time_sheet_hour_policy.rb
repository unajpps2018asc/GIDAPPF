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
# Archivo GIDAPPF/gidappf/app/policies/time_sheet_hour_policy.rb          #
###########################################################################

###########################################################################
# Políticas de acceso pundit para que los horarios sean creados solo por  #
# los administradores y vistos por los secretarios, no por docentes y ni  #
# estudiantes que estén asignados por la relación usercommisionrole.      #
###########################################################################
class TimeSheetHourPolicy < ApplicationPolicy
  #####################################################################
  # Prerequisitos:                                                    #
  #           1) Acción index definida en TimeSheetHourController     #
  #           1) Setear el valorde GIDAPPF_SYSADMIN                   #
  # Devolución: idem show                                             #
  #####################################################################
  def index?
    show?
  end

  ###########################################################################
  # Prerequisitos:                                                          #
  #           1) Acción edit definida en TimeSheetHourController            #
  # Devolución: delega el valor de update, para editar roles                #
  ###########################################################################
  def edit?
    create?
  end

  ##############################################################################
  # Prerequisitos:                                                             #
  #           1) Acción update definida en TimeSheetHourController             #
  #           1) Setear el valorde GIDAPPF_SYSADMIN                            #
  # Devolución: Crea una nueva comision si @user es el de testeo o @issadmin   #
  #             es true o si @roleaccess es mayor a 30.0                       #
  ##############################################################################
  def update?
    create?
  end

  ###########################################################################
  # Prerequisitos:                                                          #
  #           1) Acción destroy definida en TimeSheetHourController         #
  # Devolución: delega el valor de update, para borrar roles                #
  ###########################################################################
  def destroy?
    create?
  end

  ###########################################################################
  # Prerequisitos:                                                          #
  #           1) Acción new definida en TimeSheetHourController             #
  # Devolución: delega el valor de create, para nuevos roles                #
  ###########################################################################
  def multiple_new?
    create?
  end

  ##############################################################################
  # Prerequisitos:                                                             #
  #           1) Acción show definida en RolesController                       #
  #           1) Setear el valorde GIDAPPF_SYSADMIN                            #
  # Devolución: Crea una nueva comision si @user es el de testeo o @issadmin   #
  #             es true o si @roleaccess es mayor a 20.0                       #
  ##############################################################################
  def show?
    self.set_is_sysadmin
    self.set_roleaccess
    @user.email.eql?( 'john@example.com')||@issysadmin||@roleaccess>20.0
  end

  ###########################################################################
  # Prerequisitos:                                                          #
  #           1) Acción edit definida en CommissionsController              #
  # Devolución: delega el valor de update, para editar roles                #
  ###########################################################################
  def edit?
    create?
  end

  ##############################################################################
  # Prerequisitos:                                                             #
  #           1) Acción update definida en TimeSheetHourController             #
  #           1) Setear el valorde GIDAPPF_SYSADMIN                            #
  # Devolución: Crea una nueva comision si @user es el de testeo o @issadmin   #
  #             es true o si @roleaccess es mayor a 20.0                       #
  ##############################################################################
  def update?
    create?
  end

  ###########################################################################
  # Prerequisitos:                                                          #
  #           1) Acción destroy definida en TimeSheetHourController         #
  # Devolución: delega el valor de update, para borrar roles                #
  ###########################################################################
  def destroy?
    create?
  end

  #############################################################################
  # Prerequisitos:                                                            #
  #           1) Acción create definida en TimeSheetHourController            #
  #           1) Setear el valorde GIDAPPF_SYSADMIN                           #
  # Devolución: Crea una nueva comision si @user es el de testeo o @issadmin  #
  #             es true o si @roleaccess es mayor a 30.0                      #
  #############################################################################
  def create?
    self.set_is_sysadmin
    self.set_roleaccess
    @user.email.eql?( 'john@example.com')||@issysadmin||@roleaccess>30.0
  end

end
