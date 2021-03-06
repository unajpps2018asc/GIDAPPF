#############################################################################
# Universidad Nacional Arturo Jauretche                                     #
# Instituto de Ingeniería y Agronomía -Ingeniería en Informática            #
# Práctica Profesional Supervisada Nro 12 - Segundo cuatrimestre de 2018    #
#    <<Gestión Integral de Alumnos Para el Proyecto Fines>>                 #
# Tutores:                                                                  #
#    - UNAJ: Dr. Ing. Morales, Martín                                       #
#    - ORGANIZACIÓN: Ing. Cortes Bracho, Oscar                              #
#    - ORGANIZACIÓN: Mg. Ing. Diego Encinas                                 #
#    - TAPTA: Dra. Ferrari, Mariela                                         #
# Autor: Ap. Daniel Rosatto <danielrosatto@gmail.com>                       #
# Archivo GIDAPPF/gidappf/app/controllers/setsusersaccess_controller.rb     #
#############################################################################
class SetsusersaccessController < ApplicationController

  def settings
    @usercommissionroles=Usercommissionrole.all
    authorize @usercommissionroles
    @roleOpts=Role.where('level > ?', 1)
    ############################################################################
    # devolucion del controlador, respond_to                                   #
    ############################################################################
    respond_to do |format|
      format.html { }
      format.json { head :no_content }
    end
  end

end
