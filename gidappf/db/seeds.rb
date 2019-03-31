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
###########################################################################
# OBJETOS DE SISTEMA, CONFIGURABLES                                       #
###########################################################################
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
    enabled: true, level: 10.0 #REQUERIDO POR SISTEMA
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
    enabled: true, level: 30.0 #REQUERIDO POR SISTEMA
  },
  {
    name: "Administrador",#id4
    description: "Usuario diseñador de las cursadas del Plan Fines.",
    created_at: gidappf_start_time,
    enabled: true, level: 40.0 #REQUERIDO POR SISTEMA
  },
  {
    name: "Autogestionado",#id5
    description: "Usuario que se registra sin intervención de la administración.",
    created_at: gidappf_start_time,
    enabled: false # level default 0 #REQUERIDO POR SISTEMA
  },
  {
    name: "Ingresante",#id6
    description: "Comienza el tramite para participar del Plan Fines, se reserva el email. Si trata de ingresar al sistema, accede al sistema de cambio de clave, ya que la clave es por defecto.",
    created_at: gidappf_start_time,
    enabled: false, level: 10.0 #REQUERIDO POR SISTEMA
  }
])
p "[GIDAPPF] Creados #{Role.count} Roles"

####################################################################################
# Valores de bloqueo de usuario joho@example.com, accesible solo en RAILS_ENV=test #
# Usuario student@gidappf.edu.ar que guarda la plantilla del perfil                #
####################################################################################
User.destroy_all
LockEmail::LIST.each do |e| #REQUERIDO POR SISTEMA
  aux=Devise::Encryptor.digest(User,rand(5..30))
  User.new({email: e, password: aux, password_confirmation: aux}).save
end
p "[GIDAPPF] Creados #{User.count} usuarios de bloqueo"

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
p "[GIDAPPF] Creada Comision de ingresantes" #REQUERIDO POR SISTEMA

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
#REQUERIDO POR SISTEMA
p "[GIDAPPF] Creados #{Profile.count} Perfiles"

Document.destroy_all
Document.create!([
    {
      profile_id: Profile.first.id,
      user_id: User.find_by(email: LockEmail::LIST[1] ).id
     }
  ])
#REQUERIDO POR SISTEMA
p "[GIDAPPF] Creados #{Document.count} Documentos"

ClientSideValidator.destroy_all
ClientSideValidator.create!([
    {
      content_type: 'GIDAPPF read only',
      script: ''#REQUERIDO POR SISTEMA
    },
    {
      content_type: "GIDAPPF alphanumerics",
      script: "$(document).ready(function() {
      if( $(event.target).val().match(/^[a-zA-Z0-9\\s]+$/) == null ) {
          $(event.target).val('');
          $( \"<p class='validation-error'>Alphanumeric error.</p>\" ).appendTo($(event.target).parent());
        }
      });"
    },
    {
      content_type: "GIDAPPF dates",
      script: "$(document).ready(function() {
      if(Number.isNaN((new Date($(event.target).val())).getTime()) ) {
          $(event.target).val('');
          $( \"<p class='validation-error'>Date error.</p>\" ).appendTo($(event.target).parent());
        }
      });"
    },
    {
      content_type: "GIDAPPF numbers",
      script: "$(document).ready(function() {
      if( $(event.target).val().match(/^[0-9]+$/) == null ) {
          $(event.target).val('');
          $( \"<p class='validation-error'>Number error.</p>\" ).appendTo($(event.target).parent());
        }
      });"
    },
    {
      content_type: "GIDAPPF words",
      script: "$(document).ready(function() {
        if($(event.target).val().match(/^[a-zA-Z\\s]+$/) == null) {
            $(event.target).val('');
            $( \"<p class='validation-error'>Word error.</p>\" ).appendTo($(event.target).parent());
          }
      });"
    }
])

p "[GIDAPPF] Creados #{ClientSideValidator.count} Validadores"

ProfileKey.destroy_all
ProfileKey.create!([
    {#REQUERIDO POR SISTEMA
      key: 'Nombre:',#0
      profile_id: Profile.first.id,
      client_side_validator_id:ClientSideValidator.find_by(content_type: 'GIDAPPF words').id
    },{
      key: 'Apellido:',#1
      profile_id: Profile.first.id,
      client_side_validator_id:ClientSideValidator.find_by(content_type: 'GIDAPPF words').id
    },{ #REQUERIDO POR SISTEMA
      key: 'DNI:',#2
      profile_id: Profile.first.id,
      client_side_validator_id:ClientSideValidator.find_by(content_type: 'GIDAPPF read only').id
    },{
      key: 'Fecha de Nacimiento:',#3
      profile_id: Profile.first.id,
      client_side_validator_id:ClientSideValidator.find_by(content_type: 'GIDAPPF dates').id
    },{
      key: 'CUIL:',#4
      profile_id: Profile.first.id,
      client_side_validator_id:ClientSideValidator.find_by(content_type: 'GIDAPPF numbers').id
    },{
      key: 'Grupo sanguíneo:',#5
      profile_id: Profile.first.id,
      client_side_validator_id:ClientSideValidator.find_by(content_type: 'GIDAPPF words').id
    },{
      key: 'Dirección:',#6
      profile_id: Profile.first.id,
      client_side_validator_id:ClientSideValidator.find_by(content_type: 'GIDAPPF alphanumerics').id
    },{
      key: 'Barrio:',#7
      profile_id: Profile.first.id,
      client_side_validator_id:ClientSideValidator.find_by(content_type: 'GIDAPPF words').id
    },{
      key: 'Localidad:',#8
      profile_id: Profile.first.id,
      client_side_validator_id:ClientSideValidator.find_by(content_type: 'GIDAPPF words').id
    },{
      key: 'CP:',#9
      profile_id: Profile.first.id,
      client_side_validator_id:ClientSideValidator.find_by(content_type: 'GIDAPPF alphanumerics').id
    },{
      key: 'Teléfono:',#10
      profile_id: Profile.first.id,
      client_side_validator_id:ClientSideValidator.find_by(content_type: 'GIDAPPF numbers').id
    },{
      key: 'Cobertura médica:',#11
      profile_id: Profile.first.id,
      client_side_validator_id:ClientSideValidator.find_by(content_type: 'GIDAPPF words').id
    },{
      key: '1)Lugar de atención médica en caso de emergencia:',#12
      profile_id: Profile.first.id,
      client_side_validator_id:ClientSideValidator.find_by(content_type: 'GIDAPPF words').id
    },{
      key: 'Dirección de (1):',#13
      profile_id: Profile.first.id,
      client_side_validator_id:ClientSideValidator.find_by(content_type: 'GIDAPPF alphanumerics').id
    },{
      key: 'Barrio de (1):',#14
      profile_id: Profile.first.id,
      client_side_validator_id:ClientSideValidator.find_by(content_type: 'GIDAPPF words').id
    },{
      key: 'Localidad de (1):',#15
      profile_id: Profile.first.id,
      client_side_validator_id:ClientSideValidator.find_by(content_type: 'GIDAPPF words').id
    },{
      key: 'Teléfono de (1):',#16
      profile_id: Profile.first.id,
      client_side_validator_id:ClientSideValidator.find_by(content_type: 'GIDAPPF numbers').id
    },{
      key: '2)Trabaja actualmente en:',#17
      profile_id: Profile.first.id,
      client_side_validator_id:ClientSideValidator.find_by(content_type: 'GIDAPPF words').id
    },{
      key: 'Horario de trabajo (2):',#18
      profile_id: Profile.first.id,
      client_side_validator_id:ClientSideValidator.find_by(content_type: 'GIDAPPF alphanumerics').id
    },{
      key: 'Busca trabajo:',#19
      profile_id: Profile.first.id,
      client_side_validator_id:ClientSideValidator.find_by(content_type: 'GIDAPPF words').id
    },{
      key: '3) Últimos estudios cursados:',#20
      profile_id: Profile.first.id,
      client_side_validator_id:ClientSideValidator.find_by(content_type: 'GIDAPPF words').id
    },{
      key: 'Establecimiento de (3):',#21
      profile_id: Profile.first.id,
      client_side_validator_id:ClientSideValidator.find_by(content_type: 'GIDAPPF words').id
    },{ #REQUERIDO POR SISTEMA
      key: 'Se inscribe a cursar:',#22
      profile_id: Profile.first.id,
      client_side_validator_id:ClientSideValidator.find_by(content_type: 'GIDAPPF words').id
    },{ #REQUERIDO POR SISTEMA
      key: 'Elección de turno desde[Hr]:',#23
      profile_id: Profile.first.id,
      client_side_validator_id:ClientSideValidator.find_by(content_type: 'GIDAPPF numbers').id
    },{ #REQUERIDO POR SISTEMA
      key: 'Elección de turno hasta[Hr]:',#24
      profile_id: Profile.first.id,
      client_side_validator_id:ClientSideValidator.find_by(content_type: 'GIDAPPF numbers').id
    },{
      key: 'Segunda opción de turno desde[Hr]:',#25
      profile_id: Profile.first.id,
      client_side_validator_id:ClientSideValidator.find_by(content_type: 'GIDAPPF numbers').id
    },{
      key: 'Segunda opción de turno hasta[Hr]:',#26
      profile_id: Profile.first.id,
      client_side_validator_id:ClientSideValidator.find_by(content_type: 'GIDAPPF numbers').id
    },{
      key: 'Hijos:',#27
      profile_id: Profile.first.id,
      client_side_validator_id:ClientSideValidator.find_by(content_type: 'GIDAPPF words').id
    },{
      key: 'Padece enfermedad:',#28
      profile_id: Profile.first.id,
      client_side_validator_id:ClientSideValidator.find_by(content_type: 'GIDAPPF words').id
    },{
      key: 'Toma medicación:',#29
      profile_id: Profile.first.id,
      client_side_validator_id:ClientSideValidator.find_by(content_type: 'GIDAPPF words').id
    },{
      key: 'Alérgico/a a:',#30
      profile_id: Profile.first.id,
      client_side_validator_id:ClientSideValidator.find_by(content_type: 'GIDAPPF words').id
    },{
      key: 'Dejó de estudiar aproximadamente hace:',#31
      profile_id: Profile.first.id,
      client_side_validator_id:ClientSideValidator.find_by(content_type: 'GIDAPPF words').id
    },{
      key: 'Materia que le cuesta más:',#32
      profile_id: Profile.first.id,
      client_side_validator_id:ClientSideValidator.find_by(content_type: 'GIDAPPF words').id
    },{
      key: 'Luego de egresar continuaría estudiando:',#33
      profile_id: Profile.first.id,
      client_side_validator_id:ClientSideValidator.find_by(content_type: 'GIDAPPF words').id
    },{
      key: 'Copia de DNI presentada:',#34
      profile_id: Profile.first.id,
      client_side_validator_id:ClientSideValidator.find_by(content_type: 'GIDAPPF words').id
    },{
      key: 'Copia de partida de nacimiento presentada:',#35
      profile_id: Profile.first.id,
      client_side_validator_id:ClientSideValidator.find_by(content_type: 'GIDAPPF words').id
    },{
      key: 'Copia de constancia de CUIL presentada:',#36
      profile_id: Profile.first.id,
      client_side_validator_id:ClientSideValidator.find_by(content_type: 'GIDAPPF words').id
    },{
      key: 'Copia de constancia de estudios previos presentada:',#37
      profile_id: Profile.first.id,
      client_side_validator_id:ClientSideValidator.find_by(content_type: 'GIDAPPF words').id
    },{
      key: '2 Fotos 4x4 precentadas:',#38
      profile_id: Profile.first.id,
      client_side_validator_id:ClientSideValidator.find_by(content_type: 'GIDAPPF words').id
    },{
      key: 'Comentarios adicionales:',#39
      profile_id: Profile.first.id,
      client_side_validator_id:ClientSideValidator.find_by(content_type: 'GIDAPPF alphanumerics').id
    }
])
p "[GIDAPPF] Creados #{ProfileKey.count} claves de perfil"
