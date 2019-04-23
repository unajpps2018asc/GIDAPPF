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
# Archivo GIDAPPF/gidappf/app/policies/application_policy.rb              #
###########################################################################
class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    false
  end

  def show?
    false
  end

  def create?
    false
  end

  def new?
    create?
  end

  def update?
    false
  end

  def edit?
    update?
  end

  def destroy?
    false
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope.all
    end
  end

  protected

  ###########################################################################
  # Prerequisitos:                                                          #
  #           1) Modelo de datos inicializado                               #
  # Devolución: variable global @issysadmin en true si el @user no tiene    #
  #             una relacion en usercommisionrele                           #
  ###########################################################################
  def set_is_sysadmin
    begin
      my_record = Usercommissionrole.joins(:user).find_by(user: @user)
    rescue ActiveRecord::RecordNotFound => e
      my_record = nil
    end
    if my_record === nil then @issysadmin=true else @issysadmin=false end
  end

  ######################################################################################################################
  # Prerequisitos:                                                                                                     #
  #           1) Modelo de datos inicializado                                                                          #
  # Devolución: 40 si el usercommisionrole relaciona a @user en alguna de sus comisiones con el rol 4 al menos una vez #
  #             30 si el usercommisionrole relaciona a @user en alguna de sus comisiones con el rol 3 al menos una vez #
  #             20 si el usercommisionrole relaciona a @user en alguna de sus comisiones con el rol 2 al menos una vez #
  #             10 si el usercommisionrole relaciona a @user en alguna de sus comisiones con el rol 3 al menos una vez #
  #             -10 si el usercommisionrole no relaciona a @user en ninguna comision                                   #
  ######################################################################################################################
  def set_roleaccess
    # @roleaccess=-20.0
    # begin
    #   records = Usercommissionrole.where(user_id: @user.id)
    # rescue ActiveRecord::RecordNotFound => e1
    #   records = nil
    # end
    # # Alternativa:
    # # @user.usercommissionrole.each do |r| if
    # #   r.role.level > @roleaccess
    # #     @roleaccess=r.role.level
    # #   end
    # # end
    # if records === nil then @roleaccess=-10.0
    # else
    #   records.each do |my_record|
    #     if my_record.role.level > @roleaccess
    #       @roleaccess=my_record.role.level
    #     end
    #   end
    # end
    @roleaccess=-10.0
    unless @user.usercommissionroles.empty? then
      l=Role.where.not(enabled: false).where(:id => @user.usercommissionroles.pluck(:role_id).uniq).maximum(:level)
    end
    unless l.nil? then @roleaccess=l end
  end

end
