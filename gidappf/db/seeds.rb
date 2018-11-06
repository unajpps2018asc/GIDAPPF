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
# This file should contain all the record creation needed to seed the 
database
# with its default values.
# The data can then be loaded with the rails db:seed command
# (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'LoTR' }])
#   Character.create(name: 'Luke', movie: movies.first)
Role.destroy_all
Role.create!([
  {name: "Administrador", description: "Usuario diseñador de las cursadas del Plan Fines.",created_at: "2018-10-31 23:21:00", update_at: "2018-10-31 23:17:00", enabled: true},
  {name: "Secretario", description: "Usuario planificador de las cursadas del Plan Fines.", created_at: "2018-10-31 23:21:00", update_at: "2018-10-31 23:17:00", enabled: true},
  {name: "Estudiante", description: "Usuario que participa de las cursadas y esta asignado al Plan Fines.", created_at: "2018-10-31 23:21:00", update_at: "2018-10-31 23:17:00", enabled: true},
  {name: "Ingresante", description: "Usuario que comienza el tramite para participar del Plan Fines", created_at: "2018-10-31 23:21:00", update_at: "2018-10-31 23:21:00", enabled: true}
])

p "[GIDAPPF] Creados #{Role.count} Roles"
