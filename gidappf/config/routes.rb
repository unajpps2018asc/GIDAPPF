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
# Archivo GIDAPPF/gidappf/config/routes.rb                                #
###########################################################################

Rails.application.routes.draw do
  resources :class_room_institutes
  devise_for :users, controllers: {
    registrations: 'user/registrations'
  }


  resources :usercommissionroles,only:[:edit]
  # get 'usercommissionroles'
  get 'setsusersaccess/settings'
  resources :commissions
  resources :roles
	root to: "home#index"
end
