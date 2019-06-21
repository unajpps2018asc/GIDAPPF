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
# Archivo GIDAPPF/gidappf/app/policies/input_policy.rb                    #
###########################################################################
class InputPolicy < ApplicationPolicy

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
    set_is_sysadmin
    set_roleaccess
    @user.email.eql?( 'john@example.com')||@issysadmin||@roleaccess>10.0
  end

  ###########################################################################
  # Prerequisitos:                                                          #
  #           1) Acción show definida en ProfilesController                 #
  # Devolución: true, si roleaccess es mayor a 10                           #
  ###########################################################################
  def show?
    set_is_sysadmin
    set_roleaccess
    @user.email.eql?( 'john@example.com')||is_my_profile?||@issysadmin||@roleaccess>10.0
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
    update?
  end

  ###########################################################################
  # Prerequisitos:                                                          #
  #           1) Acción update definida en ProfilesController               #
  # Devolución: true, si roleaccess es mayor a 20                           #
  ###########################################################################
  def update?
    set_is_sysadmin
    set_roleaccess
    @user.email.eql?('john@example.com')||@issysadmin||
    (is_my_profile? && is_not_master_document?)||@roleaccess>30.0
  end

  ###########################################################################
  # Prerequisitos:                                                          #
  #           1) Acción destroy definida en ProfilesController              #
  # Devolución: true, si roleaccess es mayor a 30                           #
  ###########################################################################
  def destroy?
    set_is_sysadmin
    set_roleaccess
    @user.email.eql?('john@example.com')||is_my_profile?
  end

  ###########################################################################
  # Prerequisitos:                                                          #
  #           1) Acción destroy definida en ProfilesController              #
  # Devolución: true, si roleaccess es mayor a 30                           #
  ###########################################################################
  def disable?
    show?
  end

  private

  def is_my_profile?
    @user.documents.present? &&
    @user.documents.first.present? &&
    @user.documents.first.profile.present? &&
    @record.documents.first.profile.eql?(@user.documents.first.profile)
  end

  def is_not_master_document?
    InfoValue.where(info_key: Input.find(@record.template_to_merge).info_keys.pluck(:id)).empty?
  end

end
