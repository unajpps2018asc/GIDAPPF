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
# Archivo GIDAPPF/gidappf/app/controllers/about_controller.rb       #
###########################################################################
class AboutController < ApplicationController
skip_before_action :authenticate_user!, :only => [:team]

  def team
    @logo_ticapps=ProfileValue.new
    @logo_ticapps.active_stored.attach(io: File.open(Rails.root.join("storage/seeds/images/layout/logo-TICAPPS-2019-01.jpg")), filename: 'noimg')
    @logo_iia_unaj=ProfileValue.new
    @logo_iia_unaj.active_stored.attach(io: File.open(Rails.root.join("storage/seeds/images/layout/logo-iia-unaj.png")), filename: 'noimg')
    @user0=ProfileValue.new
    @user0.active_stored.attach(io: File.open(Rails.root.join("storage/seeds/images/layout/user0.png")), filename: 'noimg')
    @user1=ProfileValue.new
    @user1.active_stored.attach(io: File.open(Rails.root.join("storage/seeds/images/layout/user1.png")), filename: 'noimg')
    @user2=ProfileValue.new
    @user2.active_stored.attach(io: File.open(Rails.root.join("storage/seeds/images/layout/user3.png")), filename: 'noimg')
    @user3=ProfileValue.new
    @user3.active_stored.attach(io: File.open(Rails.root.join("storage/seeds/images/layout/user2.jpg")), filename: 'noimg')
  end

end
