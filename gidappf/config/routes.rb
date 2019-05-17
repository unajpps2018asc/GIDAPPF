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
  resources :information
  resources :matters
  get 'campus_magnaments/set_campus_segmentation'
  get 'campus_magnaments/get_campus_segmentation'
  get 'profiles/second'
  get 'profiles/first'
  post 'profiles/first'
  resources :profiles
  get 'time_sheet_hours/multiple_new'
  post 'time_sheet_hours/multiple_new'
  resources :time_sheet_hours, only:[:create, :index, :show, :edit, :destroy, :update]
  get 'time_sheets/associate'
  get 'time_sheets/renew_all'
  post 'time_sheets/renew_all'
  resources :time_sheets,only:[:create, :index, :show, :edit, :destroy, :update] do
    member do
      get 'parametrize'
    end
  end
  resources :vacancies
  resources :class_room_institutes do
    member do
      get 'parametrize'
    end
  end
  devise_for :users, controllers: {
    registrations: 'user/registrations',
    sessions: 'user/sessions'
  }
  resources :usercommissionroles,only:[:edit]
  get 'setsusersaccess/settings'
  resources :commissions
  resources :roles
	root to: "home#index"
end
