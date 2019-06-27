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
    @user.email.eql?( 'john@example.com')||@issysadmin||@roleaccess>19.9
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
    @user.email.eql?('john@example.com')||@issysadmin||@roleaccess>19.9
  end

  ###########################################################################
  # Prerequisitos:                                                          #
  #           1) Acción destroy definida en ProfilesController              #
  # Devolución: true, si roleaccess es mayor a 30                           #
  ###########################################################################
  def destroy?
    set_is_sysadmin
    set_roleaccess
    @user.email.eql?('john@example.com')||(@roleaccess>39.9 && !@record.eql?(Input.find_by(title: "Administrative rules")))
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

  # def is_my_info?
  #   @user.documents.present? &&
  #   @user.documents.first.present? &&
  #   @user.documents.first.profile.present? &&
  #   @record.documents.first.profile.eql?(@user.documents.first.profile) &&
  #   @record.author.eql?(@user.documents.first.profile.id)
  # end
  #
  # def is_not_master_document?
  #   InfoValue.where(info_key: Input.find(@record.template_to_merge).info_keys.pluck(:id)).empty?
  # end
  #
  # def access_by_author?
  #   out=true
  #   # if @roleaccess >= 39.9 then
  #   #   out=true
  #   # elsif @roleaccess < 39.9 && @roleaccess >= 30.0 then
  #   #   out=!(Document.where(user_id: User.where(email: LockEmail::LIST.first(2)).ids).pluck(:profile_id).include?(@record.author))
  #   # elsif @roleaccess <= 29.0 && @roleaccess > 20.0 then
  #   #   out=!(Document.where(user_id: User.where(email: LockEmail::LIST.first(3)).ids).pluck(:profile_id).include?(@record.author))
  #   # elsif @roleaccess <= 20.0 && @roleaccess >= 10.0 then
  #   #   out=!(Document.where(user_id: User.where(email: LockEmail::LIST.first(4)).ids).pluck(:profile_id).include?(@record.author))
  #   # end
  #   out
  # end
  #
  # def is_public?
  #   Document.where(user_id: User.where(email: LockEmail::LIST).ids).pluck(:profile_id).include?(@record.author) &&
  #   User.where(email: LockEmail::LIST).ids.include?(@record.documents.first.user_id)
  # end

end
