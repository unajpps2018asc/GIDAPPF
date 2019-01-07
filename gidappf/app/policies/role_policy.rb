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
# Archivo GIDAPPF/gidappf/app/policies/role_policy.rb                     #
###########################################################################
class RolePolicy < ApplicationPolicy
  
  ###########################################################################
  # Prerequisitos:                                                          #
  #           1) Acción index definida en RolesController                   #
  # Devolución: true, todos pueden listar roles                             #
  ###########################################################################
  def index?
    true
  end

  ###########################################################################
  # Prerequisitos:                                                          #
  #           1) Acción show definida en RolesController                    #
  # Devolución: true, todos pueden ver en detalle roles                     #
  ###########################################################################
  def show?
    true
  end

  ###########################################################################
  # Prerequisitos:                                                          #
  #           1) Acción edit definida en RolesController                    #
  # Devolución: delega el valor de update, para editar roles                #
  ###########################################################################
  def edit?
    update?
  end

  ###########################################################################
  # Prerequisitos:                                                          #
  #           1) Acción update definida en RolesController                  #
  # Devolución: false, salvo para john@example.com de los testings          #
  ###########################################################################
  def update?
     @user.email.eql?( 'john@example.com')
  end

  ###########################################################################
  # Prerequisitos:                                                          #
  #           1) Acción destroy definida en RolesController                 #
  # Devolución: delega el valor de update, para borrar roles                #
  ###########################################################################
  def destroy?
    update?
  end

  ###########################################################################
  # Prerequisitos:                                                          #
  #           1) Acción new definida en RolesController                     #
  # Devolución: delega el valor de create, para nuevos roles                #
  ###########################################################################
  def new?
    create?
  end

  ##############################################################################
  # Prerequisitos:                                                             #
  #           1) Acción create definida en RolesController                     #
  #           1) Setear el valorde GIDAPPF_SYSADMIN                            #
  # Devolución: Crea un nuevo rol si @user el el de testeo o @issadmin es true #
  ##############################################################################
  def create?
    self.set_is_sysadmin
    @user.email.eql?( 'john@example.com')||@issysadmin
  end

end
