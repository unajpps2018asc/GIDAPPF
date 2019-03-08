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
# Valores de Roles. Se debe jerarquizar a mayor level, mayor jerarquia    #
###########################################################################
Role.destroy_all
Role.create!([
  {
    name: "Ingresante",#id1
    description: "Comienza el tramite para participar del Plan Fines, se reserva el email. Cambio de clave, ya realizada.",
    created_at: gidappf_start_time,
    enabled: true, level: 10.0
  },
  {
    name: "Estudiante",#id2
    description: "Usuario que participa de las cursadas y esta asignado al Plan Fines.",
    created_at: gidappf_start_time,
    enabled: true, level: 20.0
  },
  {
    name: "Secretario",#id3
    description: "Usuario planificador de las cursadas del Plan Fines.",
    created_at: gidappf_start_time,
    enabled: true, level: 30.0
  },
  {
    name: "Administrador",#id4
    description: "Usuario diseñador de las cursadas del Plan Fines.",
    created_at: gidappf_start_time,
    enabled: true, level: 40.0
  },
  {
    name: "Autogestionado",#id5
    description: "Usuario que se registra sin intervención de la administración.",
    created_at: gidappf_start_time,
    enabled: false # level default 0
  },
  {
    name: "Ingresante",#id6
    description: "Comienza el tramite para participar del Plan Fines, se reserva el email. Si trata de ingresar al sistema, accede al sistema de cambio de clave, ya que la clave es por defecto.",
    created_at: gidappf_start_time,
    enabled: false, level: 10.0
  }
])
p "[GIDAPPF] Creados #{Role.count} Roles"

####################################################################################
# Valores de bloqueo de usuario joho@example.com, accesible solo en RAILS_ENV=test #
# Usuario student@gidappf.edu.ar que guarda la plantilla del perfil                #
####################################################################################
User.destroy_all
LockEmail::LIST.each do |e|
  aux=Devise::Encryptor.digest(User,rand(5..30))
  User.new({email: e, password: aux, password_confirmation: aux}).save
end
p "[GIDAPPF] Creados #{User.count} usuarios de bloqueo"

###########################################################################
# Array auxiliar                                                          #
###########################################################################
aulas=Array.new
4.times {|i|
  e=[i+1,"estudiantes#{i+1}","Descripción nro. #{i+1} generada automáticamente"]
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
      name: "Aula de #{a[1]}",
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

######################################################################
# Plantilla del perfil de alumno                                     #
######################################################################
Profile.destroy_all
Profile.create!([
    {
      name: 'StudentProfile',
      description: 'Any student template profile',
      valid_from: gidappf_start_time,
      valid_to: gidappf_end_time
      }
    ])

p "[GIDAPPF] Creados #{Profile.count} Perfiles"

Document.destroy_all
Document.create!([
    {
      profile_id: Profile.first.id,
      user_id: User.find_by(email: 'student@gidappf.edu.ar').id
     }
  ])

p "[GIDAPPF] Creados #{Document.count} Documentos"

ProfileKey.destroy_all
ProfileKey.create!([
    {
      key: 'Nombre:',
      profile_id: Profile.first.id
    },{
      key: 'Apellido:',
      profile_id: Profile.first.id
    },{
      key: 'DNI:',
      profile_id: Profile.first.id
    }
])
#User.find_by(email: 'student@gidappf.edu.ar').document.first.profile.profile_key.find(1).key es "Nombre"
#User.find_by(email: 'student@gidappf.edu.ar').document.first.profile.profile_key.find(2).key es "Apellido"
#User.find_by(email: 'student@gidappf.edu.ar').document.first.profile.profile_key.find(3).key es "DNI"
p "[GIDAPPF] Creados #{ProfileKey.count} claves de perfil"
