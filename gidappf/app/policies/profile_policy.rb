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
# Archivo GIDAPPF/gidappf/app/policies/profile_policy.rb                  #
###########################################################################
class ProfilePolicy < ApplicationPolicy

  ###########################################################################
  # Prerequisitos:                                                          #
  #           1) Acción new definida en ProfilesController                  #
  # Devolución: delega el valor de new, para update profiles                #
  ###########################################################################
  def new?
    false
  end

  ###########################################################################
  # Prerequisitos:                                                          #
  #           1) Acción index definida en ProfilesController                #
  # Devolución: delega el valor de index, para show profiles                #
  ###########################################################################
  def index?
    self.set_is_sysadmin
    self.set_roleaccess
    @user.email.eql?( 'john@example.com')||@issysadmin||@roleaccess>10.0
  end

  ###########################################################################
  # Prerequisitos:                                                          #
  #           1) Acción show definida en ProfilesController                 #
  # Devolución: true, si roleaccess es mayor a 10                           #
  ###########################################################################
  def show?
    update?
  end

  ###########################################################################
  # Prerequisitos:                                                          #
  #           1) Acción edit definida en ProfilesController                 #
  # Devolución: delega el valor de edit, para update profiles               #
  ###########################################################################
  def edit?
    update?
  end

  ###########################################################################
  # Prerequisitos:                                                          #
  #           1) Acción create definida en ProfilesController               #
  # Devolución: delega el valor de edit, para update profiles               #
  ###########################################################################
  def create?
    first?
  end

  ###########################################################################
  # Prerequisitos:                                                          #
  #           1) Acción update definida en ProfilesController               #
  # Devolución: true, si roleaccess es mayor a 20                           #
  ###########################################################################
  def update?
    self.set_is_sysadmin
    self.set_roleaccess
    @user.email.eql?( 'john@example.com')||
    @issysadmin||is_my_profile?||@roleaccess>20.0
  end

  ###########################################################################
  # Prerequisitos:                                                          #
  #           1) Acción destroy definida en ProfilesController              #
  # Devolución: true, si roleaccess es mayor a 30                           #
  ###########################################################################
  def destroy?
    self.set_is_sysadmin
    self.set_roleaccess
    @user.email.eql?( 'john@example.com')||@issysadmin||@roleaccess>29.9
  end

  ##############################################################################
  # Prerequisitos:                                                             #
  #           1) Acción first definida en ProfilesController                   #
  # Devolución: delega el valor de edit, para update profiles                  #
  ##############################################################################
  def first?
    self.set_is_sysadmin
    self.set_roleaccess
    @user.email.eql?( 'john@example.com')||
    @issysadmin||is_my_profile?||@roleaccess>28
  end

  ##############################################################################
  # Prerequisitos:                                                             #
  #           1) Acción second definida en ProfilesController                  #
  # Devolución: delega el valor de edit, para update profiles                  #
  ##############################################################################
  def second?
    first?
  end

  def first_password_detect?
    out=false
    unless @record.documents.first.nil?
      out=!@record.documents.first.user.usercommissionroles.first.role.enabled
    end
    out
  end

  private

  def is_my_profile?
    @user.documents.present? &&
    @user.documents.first.present? &&
    @user.documents.first.profile.present? &&
    @record.eql?(@user.documents.first.profile) && @roleaccess>28.0
  end

end
