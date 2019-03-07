class Role < ApplicationRecord
  #######################################################################
  # Asociación uno a muchos: soporta que un rol sea asignada muchas     #
  #                          veces en la relación usercommissionrole    #                                                       #
  #                          Si se borra, lo hace  usercommissionrole.  #
  #######################################################################
  has_many :usercommissionroles, dependent: :delete_all
end
