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
# Archivo GIDAPPF/gidappf/test/test_helper.rb                             #
###########################################################################
ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
# require 'devise/jwt/test_helpers' # Gema devise-jwt que mantiene la sesion para todos los test en api mode
require 'minitest/utils/rails/locale' # Gema minitest-utils, da soporte I18n a los test

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in abc order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
end
