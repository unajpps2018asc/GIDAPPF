###########################################################################
# Universidad Nacional Arturo Jauretche                                   #
# Instituto de Ingeniería y Agronomía -Ingeniería en Informática          #
# Práctica Profesional Supervisada Nro 12 - Segundo cuatrimestre de 2018  #
#       <<Gestión Integral de Alumnos Para el Proyecto Fines>>            #
# Tutores:                                                                #
#       - UNAJ: Dr. Ing. Morales, Martín                                  #
#       - INSTITUCION: Ing. Cortes Bracho, Oscar                          #
#       - TAPTA: Dra. Ferrari, Mariela                                    #
# Autor: Ap. Daniel Rosatto <danielrosatto@gmail.com>                     #
###########################################################################
Rails.application.routes.draw do
	devise_for :users
	# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
	root to: "home#index"
end
#Rails.application.routes.draw do
#  devise_for :users
#  resources :roles
#  root 'pages#home'
#end
