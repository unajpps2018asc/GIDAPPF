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
# Archivo GIDAPPF/gidappf/app/policies/usercommissioonroles_policy.rb     #
###########################################################################

###########################################################################
# Políticas de acceso pundit para que los accesos sean creados solo por
# los administradores y no vistas por los secretarios ni, docentes y ni estudiantes
# que estén asignados por la relación usercommisionrole.
###########################################################################
class UsercommissionrolePolicy < ApplicationPolicy

  def edit?
    self.set_is_sysadmin
    self.set_roleaccess
    @user.email.eql?( 'john@example.com')||@issysadmin||@roleaccess>30.0
  end

  #########################################################################
  # Políticas de acceso para setsusersaccess_controller                   #
  #########################################################################
  def settings?
    self.set_is_sysadmin
    self.set_roleaccess
    @user.email.eql?( 'john@example.com')||@issysadmin||@roleaccess>30.0
  end

  #########################################################################
  # Políticas de acceso para campus_magnaments_controller                 #
  #########################################################################
  def set_campus_segmentation?
    self.set_is_sysadmin
    self.set_roleaccess
    @user.email.eql?( 'john@example.com')||@issysadmin||@roleaccess>29.0
  end

  #########################################################################
  # Políticas de acceso para profiles_controller                          #
  #########################################################################
  def generate?
    self.set_is_sysadmin
    self.set_roleaccess
    @user.email.eql?( 'john@example.com')||@issysadmin||@roleaccess>28.0
  end

end
