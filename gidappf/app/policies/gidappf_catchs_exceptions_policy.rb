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
# Archivo GIDAPPF/gidappf/app/policies/gidappf_catchs_exceptions_policy.rb#
###########################################################################
class GidappfCatchsExceptionsControllerPolicy < ApplicationPolicy
  ###########################################################################
  # Prerequisitos:                                                          #
  #           1) Acción index definida en ClassRoomInsituteController       #
  # Devolución: true, todos pueden listar aulas                             #
  ###########################################################################
  def first_password_detect?
    !@record.documents.first.user.usercommissionroles.first.role.enabled
  end

end
