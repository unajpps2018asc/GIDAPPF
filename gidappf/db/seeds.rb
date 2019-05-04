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
    enabled: true # level default 0 #REQUERIDO POR SISTEMA
  },
  {
    name: "Ingresante",#id6
    description: "Comienza el tramite para participar del Plan Fines, se reserva el email. Si trata de ingresar al sistema, accede al sistema de cambio de clave, ya que la clave es por defecto.",
    created_at: gidappf_start_time,
    enabled: false, level: 10.0 #REQUERIDO POR SISTEMA
  },
  {
    name: "Docente",#id7
    description: "Responsable de la comisión asignada, ya sea luego de ser autogestionado o un perfil.",
    created_at: gidappf_start_time,
    enabled: true, level: 29.0 #REQUERIDO POR SISTEMA
  },
  {
    name: "Docente",#id8
    description: "Responsable de la comisión asignada, ya sea luego de ser autogestionado o un perfil, con contraseña insegura",
    created_at: gidappf_start_time,
    enabled: false, level: 29.0 #REQUERIDO POR SISTEMA
  },
  {
    name: "Estudiante",#id9
    description: "Usuario que participa de las cursadas y esta asignado al Plan Fines, pero con contraseña insegura.",
    created_at: gidappf_start_time,
    enabled: false, level: 20.0
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

###########################################################
# Plantillas de perfiles                                  #
###########################################################
Profile.destroy_all
Profile.create!([
    {
      name: 'StudentProfile',
      description: 'Any student template profile',
      valid_from: gidappf_start_time,
      valid_to: gidappf_end_time
    },{
      name: 'DocentProfile',
      description: 'Any docent template profile',
      valid_from: gidappf_start_time,
      valid_to: gidappf_end_time
    },{
      name: 'SecretaryProfile',
      description: 'Any secretary template profile',
      valid_from: gidappf_start_time,
      valid_to: gidappf_end_time
    },{
      name: 'administratorProfile',
      description: 'Any administrator template profile',
      valid_from: gidappf_start_time,
      valid_to: gidappf_end_time
    }
  ])
#REQUERIDO POR SISTEMA
p "[GIDAPPF] Creados #{Profile.count} Perfiles"

Document.destroy_all
lock=LockEmail::LIST
lock.shift
lock.each_with_index do |e,index|
  Document.create!([
      {
        profile_id: index + 1,
        user_id: User.find_by(email: e ).id
      }
    ])
end
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
      content_type: "GIDAPPF matters",
      script: "$(document).ready(function() {
      if( $(event.target).val().match(/^[0-9]+$/) == null ) {
          $(event.target).val('');
          $( \"<p class='validation-error'>Number error.</p>\" ).appendTo($(event.target).parent());
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
      content_type: "GIDAPPF trayects",
      script: "$(document).ready(function() {
      if( jQuery.inArray( $(event.target).val(), ['PRIMERO', 'SEGUNDO', 'TERCERO'] )  < 0 ) {
          $(event.target).val('');
          $( \"<p class='validation-error'>Choose one of ['PRIMERO', 'SEGUNDO', 'TERCERO']</p>\" ).appendTo($(event.target).parent());
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
      key: 'Nombre:',#1
      profile_id: Profile.first.id,
      client_side_validator_id:ClientSideValidator.find_by(content_type: 'GIDAPPF words').id
    },{
      key: 'Apellido:',#2
      profile_id: Profile.first.id,
      client_side_validator_id:ClientSideValidator.find_by(content_type: 'GIDAPPF words').id
    },{ #REQUERIDO POR SISTEMA
      key: 'DNI:',#3
      profile_id: Profile.first.id,
      client_side_validator_id:ClientSideValidator.find_by(content_type: 'GIDAPPF read only').id
    },{
      key: 'Fecha de Nacimiento:',#4
      profile_id: Profile.first.id,
      client_side_validator_id:ClientSideValidator.find_by(content_type: 'GIDAPPF dates').id
    },{
      key: 'CUIL:',#5
      profile_id: Profile.first.id,
      client_side_validator_id:ClientSideValidator.find_by(content_type: 'GIDAPPF numbers').id
    },{
      key: 'Grupo sanguíneo:',#6
      profile_id: Profile.first.id,
      client_side_validator_id:ClientSideValidator.find_by(content_type: 'GIDAPPF words').id
    },{
      key: 'Dirección:',#7
      profile_id: Profile.first.id,
      client_side_validator_id:ClientSideValidator.find_by(content_type: 'GIDAPPF alphanumerics').id
    },{
      key: 'Barrio:',#8
      profile_id: Profile.first.id,
      client_side_validator_id:ClientSideValidator.find_by(content_type: 'GIDAPPF words').id
    },{
      key: 'Localidad:',#9
      profile_id: Profile.first.id,
      client_side_validator_id:ClientSideValidator.find_by(content_type: 'GIDAPPF words').id
    },{
      key: 'CP:',#10
      profile_id: Profile.first.id,
      client_side_validator_id:ClientSideValidator.find_by(content_type: 'GIDAPPF alphanumerics').id
    },{
      key: 'Teléfono:',#11
      profile_id: Profile.first.id,
      client_side_validator_id:ClientSideValidator.find_by(content_type: 'GIDAPPF numbers').id
    },{
      key: 'Cobertura médica:',#12
      profile_id: Profile.first.id,
      client_side_validator_id:ClientSideValidator.find_by(content_type: 'GIDAPPF words').id
    },{
      key: '1)Lugar de atención médica en caso de emergencia:',#13
      profile_id: Profile.first.id,
      client_side_validator_id:ClientSideValidator.find_by(content_type: 'GIDAPPF words').id
    },{
      key: 'Dirección de (1):',#14
      profile_id: Profile.first.id,
      client_side_validator_id:ClientSideValidator.find_by(content_type: 'GIDAPPF alphanumerics').id
    },{
      key: 'Barrio de (1):',#15
      profile_id: Profile.first.id,
      client_side_validator_id:ClientSideValidator.find_by(content_type: 'GIDAPPF words').id
    },{
      key: 'Localidad de (1):',#16
      profile_id: Profile.first.id,
      client_side_validator_id:ClientSideValidator.find_by(content_type: 'GIDAPPF words').id
    },{
      key: 'Teléfono de (1):',#17
      profile_id: Profile.first.id,
      client_side_validator_id:ClientSideValidator.find_by(content_type: 'GIDAPPF numbers').id
    },{
      key: '2)Trabaja actualmente en:',#18
      profile_id: Profile.first.id,
      client_side_validator_id:ClientSideValidator.find_by(content_type: 'GIDAPPF words').id
    },{
      key: 'Horario de trabajo (2):',#19
      profile_id: Profile.first.id,
      client_side_validator_id:ClientSideValidator.find_by(content_type: 'GIDAPPF alphanumerics').id
    },{
      key: 'Busca trabajo:',#20
      profile_id: Profile.first.id,
      client_side_validator_id:ClientSideValidator.find_by(content_type: 'GIDAPPF words').id
    },{
      key: '3) Últimos estudios cursados:',#21
      profile_id: Profile.first.id,
      client_side_validator_id:ClientSideValidator.find_by(content_type: 'GIDAPPF words').id
    },{
      key: 'Establecimiento de (3):',#22
      profile_id: Profile.first.id,
      client_side_validator_id:ClientSideValidator.find_by(content_type: 'GIDAPPF words').id
    },{ #REQUERIDO POR SISTEMA
      key: 'Se inscribe a cursar:',#23
      profile_id: Profile.first.id,
      client_side_validator_id:ClientSideValidator.find_by(content_type: 'GIDAPPF trayects').id
    },{ #REQUERIDO POR SISTEMA
      key: 'Elección de turno desde[Hr]:',#24
      profile_id: Profile.first.id,
      client_side_validator_id:ClientSideValidator.find_by(content_type: 'GIDAPPF numbers').id
    },{ #REQUERIDO POR SISTEMA
      key: 'Elección de turno hasta[Hr]:',#25
      profile_id: Profile.first.id,
      client_side_validator_id:ClientSideValidator.find_by(content_type: 'GIDAPPF numbers').id
    },{
      key: 'Segunda opción de turno desde[Hr]:',#26
      profile_id: Profile.first.id,
      client_side_validator_id:ClientSideValidator.find_by(content_type: 'GIDAPPF numbers').id
    },{
      key: 'Segunda opción de turno hasta[Hr]:',#27
      profile_id: Profile.first.id,
      client_side_validator_id:ClientSideValidator.find_by(content_type: 'GIDAPPF numbers').id
    },{
      key: 'Hijos:',#28
      profile_id: Profile.first.id,
      client_side_validator_id:ClientSideValidator.find_by(content_type: 'GIDAPPF words').id
    },{
      key: 'Padece enfermedad:',#29
      profile_id: Profile.first.id,
      client_side_validator_id:ClientSideValidator.find_by(content_type: 'GIDAPPF words').id
    },{
      key: 'Toma medicación:',#30
      profile_id: Profile.first.id,
      client_side_validator_id:ClientSideValidator.find_by(content_type: 'GIDAPPF words').id
    },{
      key: 'Alérgico/a a:',#31
      profile_id: Profile.first.id,
      client_side_validator_id:ClientSideValidator.find_by(content_type: 'GIDAPPF words').id
    },{
      key: 'Dejó de estudiar aproximadamente hace:',#32
      profile_id: Profile.first.id,
      client_side_validator_id:ClientSideValidator.find_by(content_type: 'GIDAPPF words').id
    },{
      key: 'Materia que le cuesta más:',#33
      profile_id: Profile.first.id,
      client_side_validator_id:ClientSideValidator.find_by(content_type: 'GIDAPPF words').id
    },{
      key: 'Luego de egresar continuaría estudiando:',#34
      profile_id: Profile.first.id,
      client_side_validator_id:ClientSideValidator.find_by(content_type: 'GIDAPPF words').id
    },{
      key: 'Copia de DNI presentada:',#35
      profile_id: Profile.first.id,
      client_side_validator_id:ClientSideValidator.find_by(content_type: 'GIDAPPF words').id
    },{
      key: 'Copia de partida de nacimiento presentada:',#36
      profile_id: Profile.first.id,
      client_side_validator_id:ClientSideValidator.find_by(content_type: 'GIDAPPF words').id
    },{
      key: 'Copia de constancia de CUIL presentada:',#37
      profile_id: Profile.first.id,
      client_side_validator_id:ClientSideValidator.find_by(content_type: 'GIDAPPF words').id
    },{
      key: 'Copia de constancia de estudios previos presentada:',#38
      profile_id: Profile.first.id,
      client_side_validator_id:ClientSideValidator.find_by(content_type: 'GIDAPPF words').id
    },{
      key: '2 Fotos 4x4 precentadas:',#39
      profile_id: Profile.first.id,
      client_side_validator_id:ClientSideValidator.find_by(content_type: 'GIDAPPF words').id
    },{
      key: 'Comentarios adicionales:',#40
      profile_id: Profile.first.id,
      client_side_validator_id:ClientSideValidator.find_by(content_type: 'GIDAPPF alphanumerics').id
    }
])

ProfileKey.create!([
    {#REQUERIDO POR SISTEMA
      key: ProfileKey.find(1).key,#1 'Nombre:'
      profile_id: 2,
      client_side_validator_id: ProfileKey.find(1).client_side_validator_id
    },{
      key: ProfileKey.find(2).key,#2 'Apellido:'
      profile_id: 2,
      client_side_validator_id: ProfileKey.find(2).client_side_validator_id
    },{ #REQUERIDO POR SISTEMA
      key: ProfileKey.find(3).key,#3 DNI:
      profile_id: 2,
      client_side_validator_id: ProfileKey.find(3).client_side_validator_id
    },{
      key: ProfileKey.find(4).key,#4 'Fecha de Nacimiento:',
      profile_id: 2,
      client_side_validator_id: ProfileKey.find(4).client_side_validator_id
    },{
      key: ProfileKey.find(5).key,#'CUIL:',#5
      profile_id: 2,
      client_side_validator_id: ProfileKey.find(5).client_side_validator_id
    },{
      key: ProfileKey.find(6).key,#'Dirección:',#6
      profile_id: 2,
      client_side_validator_id: ProfileKey.find(6).client_side_validator_id
    },{
      key: ProfileKey.find(11).key,#'Teléfono:',#7
      profile_id: 2,
      client_side_validator_id: ProfileKey.find(11).client_side_validator_id
    },{
      key: 'Materias:',#8
      profile_id: 2,
      client_side_validator_id:ClientSideValidator.find_by(content_type: 'GIDAPPF matters').id
    },{
      key: ProfileKey.find(24).key,#'Elección de turno desde[Hr]:',#9
      profile_id: 2,
      client_side_validator_id: ProfileKey.find(24).client_side_validator_id
    },{ #REQUERIDO POR SISTEMA
      key: ProfileKey.find(25).key,#'Elección de turno hasta[Hr]:',#10
      profile_id: 2,
      client_side_validator_id: ProfileKey.find(25).client_side_validator_id
    }
])

p "[GIDAPPF] Creados #{ProfileKey.count} claves de perfil"
