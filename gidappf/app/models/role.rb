class Role < ApplicationRecord
  ###########################################################################
  # Asociación uno a muchos: soporta que un rol sea asignada muchas         #
  #                          veces en la relación usercommissionrole        #                                                       #
  ###########################################################################
  has_many :usercommissionrole
end
