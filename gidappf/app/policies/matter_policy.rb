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
# Archivo GIDAPPF/gidappf/app/policies/matter_policy.rb                   #
###########################################################################
class MatterPolicy < ApplicationPolicy
  ###########################################################################
  # Prerequisitos:                                                          #
  #           1) Acción index definida en ClassRoomInsituteController       #
  # Devolución: true, todos pueden listar aulas                             #
  ###########################################################################
  def index?
    show?
  end

  ###########################################################################
  # Prerequisitos:                                                          #
  #           1) Acción show definida en ClassRoomInsituteController        #
  # Devolución: true, si es como minimo un secretario.                      #
  ###########################################################################
  def show?
    self.set_is_sysadmin
    self.set_roleaccess
    @user.email.eql?( 'john@example.com')||@issysadmin||@roleaccess>20.0
  end

  ###########################################################################
  # Prerequisitos:                                                          #
  #           1) Acción edit definida en ClassRoomInsituteController        #
  # Devolución: delega el valor de update, para editar aulas                #
  ###########################################################################
  def edit?
    update?
  end

  ###########################################################################
  # Prerequisitos:                                                          #
  #           1) Acción update definida en ClassRoomInsituteController      #
  # Devolución: false, salvo para john@example.com de los testings          #
  ###########################################################################
  def update?
    self.set_is_sysadmin
    self.set_roleaccess
    @user.email.eql?( 'john@example.com')||@issysadmin||@roleaccess>30.0
  end

  ###########################################################################
  # Prerequisitos:                                                          #
  #           1) Acción destroy definida en ClassRoomInsituteController     #
  # Devolución: delega el valor de update, para borrar aulas                #
  ###########################################################################
  def destroy?
    update?
  end

  ###########################################################################
  # Prerequisitos:                                                          #
  #           1) Acción new definida en ClassRoomInsituteController         #
  # Devolución: delega el valor de create, para nuevas aulas                #
  ###########################################################################
  def new?
    create?
  end

  ###########################################################################
  # Prerequisitos:                                                          #
  #           1) Acción parametrize definida en ClassRoomInsituteController #
  # Devolución: delega el valor de create, para nuevas aulas                #
  ###########################################################################
  # def parametrize?
  #   show?
  # end
  ###########################################################################
  # Prerequisitos:                                                          #
  #           1) Acción create definida en ClassRoomInsituteController      #
  #           2) Setear el valorde GIDAPPF_SYSADMIN                         #
  # Devolución: Crea una nueva aula si @user el el de testeo o @issadmin es #
  #             true  o si @roleaccess es mayor a 30                        #
  ###########################################################################
  def create?
    self.set_is_sysadmin
    self.set_roleaccess
    @user.email.eql?( 'john@example.com')||@issysadmin||@roleaccess>30.0
  end

end
