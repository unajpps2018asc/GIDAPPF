#####################################################################################################################
# Prerequisitos:                                                                                                     #
#           1) Modelo de datos inicializado                                                                          #
# Devolución: 40 si el usercommisionrole relaciona a @user en alguna de sus comisiones con el rol 4 al menos una vez #
#             30 si el usercommisionrole relaciona a @user en alguna de sus comisiones con el rol 3 al menos una vez #
#             20 si el usercommisionrole relaciona a @user en alguna de sus comisiones con el rol 2 al menos una vez #
#             10 si el usercommisionrole relaciona a @user en alguna de sus comisiones con el rol 3 al menos una vez #
#             -10 si el usercommisionrole no relaciona a @user en ninguna comision                                   #
######################################################################################################################
module RoleAccess
  def get_role_access
    roleaccess=-20.0
    begin
      records = Usercommissionrole.where(user_id: current_user.id)
    rescue ActiveRecord::RecordNotFound => e1
      records = nil
    end
    if records == nil then roleaccess=-10.0
    else
      records.each do |my_record|
        if my_record.role.level > roleaccess
          roleaccess=my_record.role.level
        end
      end #do
    end #if
    roleaccess
  end #method

end #module
