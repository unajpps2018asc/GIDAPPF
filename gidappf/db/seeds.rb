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
# Archivo GIDAPPF/gidappf/db/migrate/seeds.rb                             #
###########################################################################
# This file should contain all the record creation needed to seed the database
# with its default values.
# The data can then be loaded with the rails db:seed command
# (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'LoTR' }])
#   Character.create(name: 'Luke', movie: movies.first)
gidappf_start_time = Time.rfc3339('1999-12-31T14:00:00-10:00')
gidappf_end_time = Time.rfc3339('3000-12-31T14:00:00-10:00')
###########################################################################
# Valores de Roles. Se debe jerarquizar a mayor id, mayor jerarquia       #
###########################################################################
Role.destroy_all
Role.create!([
  {
    name: "Ingresante",
    description: "Usuario que comienza el tramite para participar del Plan Fines",
    created_at: gidappf_start_time,
    enabled: true, level: 10.0
  },
  {
    name: "Estudiante",
    description: "Usuario que participa de las cursadas y esta asignado al Plan Fines.",
    created_at: gidappf_start_time,
    enabled: true, level: 20.0
  },
  {
    name: "Secretario",
    description: "Usuario planificador de las cursadas del Plan Fines.",
    created_at: gidappf_start_time,
    enabled: true, level: 30.0
  },
  {
    name: "Administrador",
    description: "Usuario diseñador de las cursadas del Plan Fines.",
    created_at: gidappf_start_time,
    enabled: true, level: 40.0
  }
])
p "[GIDAPPF] Creados #{Role.count} Roles"

####################################################################################
# Valores de bloqueo de usuario joho@example.com, accesible solo en RAILS_ENV=test #
####################################################################################
User.destroy_all
aux=Devise::Encryptor.digest(User,rand(5..30))
newuser = User.new({email: 'john@example.com', password: aux, password_confirmation: aux})
newuser.save

###########################################################################
# Array auxiliar Array.new(4) {|i| i.to_s } #=> ["0", "1", "2", "3"]
###########################################################################
aulas=Array.new
4.times {|i|
  e=[i+1,"Aula #{i+1}","Descripción nro. #{i+1} generada automáticamente"]
  aulas.push(e)
}

####################################################################################
# Comision de ingresantes                                                          #
####################################################################################
Commission.destroy_all
Commission.create!([
  {
    name: "Ingresantes",
    description: "Comision inicial de ingresantes",
    start_date: gidappf_start_time,
    end_date: gidappf_end_time,
    user_id: 1
    }
  ])
p "[GIDAPPF] Creada Comision de ingresantes"

###############################################################################
# Comisiones de prueba por cada aula                                          #
###############################################################################
aulas.each do |a|
  Commission.create!([
    {
      name: "C. #{a[1]}",
      description: "#{a[2]} para la comisión.",
      start_date: gidappf_start_time,
      end_date: gidappf_end_time,
      user_id: 1
      }
    ])
end
p "[GIDAPPF] Creadas #{Commission.count} Comisiones"

#############################################################################
# Aulas iniciales                                                           #
#############################################################################
ClassRoomInstitute.destroy_all
aulas.each do |a|
  ClassRoomInstitute.create!([
    {
      name: a[1],
      description: "#{a[2]} para el aula.",
      ubication: "Av. Ubicación Nº 1234",
      available_from: Time.now,
      available_to: gidappf_end_time,
      available_monday: true,
      available_tuesday: true,
      available_wednesday: true,
      available_thursday: true,
      available_friday: true,
      available_saturday: false,
      available_sunday: false,
      available_time: 24,
      capacity: 812,
      enabled: true,
    }])
end
p "[GIDAPPF] Creadas #{ClassRoomInstitute.count} Aulas"

##########################################################################
# Períodos de prueba                                                     #
##########################################################################
TimeSheet.destroy_all
Commission.all.each do |a|
  TimeSheet.create!([
    {
      commission_id: a.id,
      start_date: Date.today,
      end_date: 13.month.after,
      enabled: true
      }
    ])
end
p "[GIDAPPF] Creadas #{TimeSheet.count} Aulas"

############################################################################
# Vacantes de Aulas                                                        #
############################################################################
Vacancy.destroy_all
ClassRoomInstitute.all.each do |a|
  12.times {|i|
    Vacancy.create!([{class_room_institute_id: a.id, user_id: 1, occupant: nil, enabled: true}])
  }
end
p "[GIDAPPF] Creadas #{Vacancy.count} Vacantes"

######################################################################
# Horarios de la comision inicial                                    #
######################################################################
TimeSheetHour.destroy_all
Vacancy.all.each do |a|
  TimeSheetHour.create!([
     {
     from_hour: 0, from_min: 0, to_hour: 0, to_min: 0,
     monday: true, tuesday: true, wednesday: true, thursday: true,
     friday: true, saturday: true, sunday: true,
     vacancy_id: a.id,
     time_sheet_id: TimeSheet.first.id
     }
  ])
  end
p "[GIDAPPF] Creado #{TimeSheetHour.count} Horarios de ingresantes"
