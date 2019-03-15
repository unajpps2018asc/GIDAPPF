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

ClientSideValidator.destroy_all
ClientSideValidator.create!([
    {
      content_type: "alert",
      script: "$(document).ready(function() { if (event.target.value == 'Mirtha') {event.target.value = 'pocho'; alert(event.target.value); }});"
    }
])

ProfileKey.destroy_all
ProfileKey.create!([
    {
      key: 'Nombre:',#0
      profile_id: Profile.first.id,
    client_side_validator_id:ClientSideValidator.first.id
    },{
      key: 'Apellido:',#1
      profile_id: Profile.first.id,
    client_side_validator_id:ClientSideValidator.first.id
    },{
      key: 'DNI:',#2
      profile_id: Profile.first.id,
    client_side_validator_id:ClientSideValidator.first.id
    },{
      key: 'Fecha de Nacimiento:',#3
      profile_id: Profile.first.id,
    client_side_validator_id:ClientSideValidator.first.id
    },{
      key: 'CUIL:',#4
      profile_id: Profile.first.id,
    client_side_validator_id:ClientSideValidator.first.id
    },{
      key: 'Grupo sanguíneo:',#5
      profile_id: Profile.first.id,
    client_side_validator_id:ClientSideValidator.first.id
    },{
      key: 'Dirección:',#6
      profile_id: Profile.first.id,
    client_side_validator_id:ClientSideValidator.first.id
    },{
      key: 'Barrio:',#7
      profile_id: Profile.first.id,
    client_side_validator_id:ClientSideValidator.first.id
    },{
      key: 'Localidad:',#8
      profile_id: Profile.first.id,
    client_side_validator_id:ClientSideValidator.first.id
    },{
      key: 'CP:',#9
      profile_id: Profile.first.id,
    client_side_validator_id:ClientSideValidator.first.id
    },{
      key: 'Teléfono:',#10
      profile_id: Profile.first.id,
    client_side_validator_id:ClientSideValidator.first.id
    },{
      key: 'Cobertura médica:',#11
      profile_id: Profile.first.id,
    client_side_validator_id:ClientSideValidator.first.id
    },{
      key: '1)Lugar de atención médica en caso de emergencia:',#12
      profile_id: Profile.first.id,
    client_side_validator_id:ClientSideValidator.first.id
    },{
      key: 'Dirección de (1):',#13
      profile_id: Profile.first.id,
    client_side_validator_id:ClientSideValidator.first.id
    },{
      key: 'Barrio de (1):',#14
      profile_id: Profile.first.id,
    client_side_validator_id:ClientSideValidator.first.id
    },{
      key: 'Localidad de (1):',#15
      profile_id: Profile.first.id,
    client_side_validator_id:ClientSideValidator.first.id
    },{
      key: 'Teléfono de (1):',#16
      profile_id: Profile.first.id,
    client_side_validator_id:ClientSideValidator.first.id
    },{
      key: '2)Trabaja actualmente en:',#17
      profile_id: Profile.first.id,
    client_side_validator_id:ClientSideValidator.first.id
    },{
      key: 'Horario de trabajo (2):',#18
      profile_id: Profile.first.id,
    client_side_validator_id:ClientSideValidator.first.id
        },{
      key: 'Busca trabajo:',#19
      profile_id: Profile.first.id,
        client_side_validator_id:ClientSideValidator.first.id
        },{
      key: '3) Últimos estudios cursados:',#20
      profile_id: Profile.first.id,
        client_side_validator_id:ClientSideValidator.first.id
    },{
      key: 'Establecimiento de (3):',#21
      profile_id: Profile.first.id,
        client_side_validator_id:ClientSideValidator.first.id
    },{
      key: 'Se inscribe a cursar:',#22
      profile_id: Profile.first.id,
        client_side_validator_id:ClientSideValidator.first.id
    },{
      key: 'Elección de turno desde[Hr]:',#23
      profile_id: Profile.first.id,
        client_side_validator_id:ClientSideValidator.first.id
    },{
      key: 'Elección de turno hasta[Hr]:',#24
      profile_id: Profile.first.id,
        client_side_validator_id:ClientSideValidator.first.id
    },{
      key: 'Segunda opción de turno desde[Hr]:',#25
      profile_id: Profile.first.id,
        client_side_validator_id:ClientSideValidator.first.id
    },{
      key: 'Segunda opción de turno hasta[Hr]:',#26
      profile_id: Profile.first.id,
        client_side_validator_id:ClientSideValidator.first.id
    },{
      key: 'Hijos:',#27
      profile_id: Profile.first.id,
        client_side_validator_id:ClientSideValidator.first.id
    },{
      key: 'Padece enfermedad:',#28
      profile_id: Profile.first.id,
        client_side_validator_id:ClientSideValidator.first.id
    },{
      key: 'Toma medicación:',#29
      profile_id: Profile.first.id,
        client_side_validator_id:ClientSideValidator.first.id
    },{
      key: 'Alérgico/a a:',#30
      profile_id: Profile.first.id,
        client_side_validator_id:ClientSideValidator.first.id
    },{
      key: 'Dejó de estudiar aproximadamente hace:',#31
      profile_id: Profile.first.id,
        client_side_validator_id:ClientSideValidator.first.id
    },{
      key: 'Materia que le cuesta más:',#32
      profile_id: Profile.first.id,
        client_side_validator_id:ClientSideValidator.first.id
    },{
      key: 'Luego de egresar continuaría estudiando:',#33
      profile_id: Profile.first.id,
        client_side_validator_id:ClientSideValidator.first.id
    },{
      key: 'Copia de DNI presentada:',#34
      profile_id: Profile.first.id,
        client_side_validator_id:ClientSideValidator.first.id
    },{
      key: 'Copia de partida de nacimiento presentada:',#35
      profile_id: Profile.first.id,
        client_side_validator_id:ClientSideValidator.first.id
    },{
      key: 'Copia de constancia de CUIL presentada:',#36
      profile_id: Profile.first.id,
        client_side_validator_id:ClientSideValidator.first.id
    },{
      key: 'Copia de constancia de estudios previos presentada:',#37
      profile_id: Profile.first.id,
        client_side_validator_id:ClientSideValidator.first.id
    },{
      key: '2 Fotos 4x4 precentadas:',#38
      profile_id: Profile.first.id,
        client_side_validator_id:ClientSideValidator.first.id
      },{
        key: 'Comentarios adicionales:',#39
        profile_id: Profile.first.id,
        client_side_validator_id:ClientSideValidator.first.id
    }
])
#User.find_by(email: 'student@gidappf.edu.ar').document.first.profile.profile_key.find(1).key es "Nombre"
#User.find_by(email: 'student@gidappf.edu.ar').document.first.profile.profile_key.find(2).key es "Apellido"
#User.find_by(email: 'student@gidappf.edu.ar').document.first.profile.profile_key.find(3).key es "DNI"
p "[GIDAPPF] Creados #{ProfileKey.count} claves de perfil"
