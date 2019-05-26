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
# Archivo GIDAPPF/gidappf/db/seeds/populate_show.rb                       #
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
#######################################################################################
# OBJETOS ADICIONALES, MEJORA DE PRESENTACION                                         #
# Archivo que completa el sistema GIDAPPF con aulas, usuarios, comisiones, horarios y #
# periodos de muestra.                                                                #
# Requisitos:                                                                         #
#      1)Modelo de datos inicializado.                                                #
# Ejecucion:                                                                          #
# $ docker-compose exec --user "$(id -u):$(id -g)" website rake db:seed:populate_show #
#######################################################################################

###########################################################################
# Array auxiliar, contenido aplicable a name, description.                #
###########################################################################
aulas=Array.new
12.times {|i|
  e=[i+1,"estudiantes#{i+1}","Descripción nro. #{i+1} generada automáticamente"]
  aulas.push(e)
}
###############################################################################
# Comisiones de prueba por cada aula, creadas a partir del array auxiliar.    #
###############################################################################
aulas.first(9).each do |a|
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
###############################################################################
# Comision del turno noche.                                                   #
###############################################################################
Commission.create!([
  {
    name: "C. noche",
    description: "Descripción para la comisión noche.",
    start_date: gidappf_start_time,
    end_date: gidappf_end_time,
    user_id: 1
    }
  ])

p "[GIDAPPF] Creadas #{Commission.count} Comisiones"

#############################################################################
# Aulas iniciales, creadas a partir del array auxiliar.                     #
#############################################################################
ClassRoomInstitute.destroy_all
aulas.first(4).each do |a|
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

############################################################################
# Vacantes de Aulas, por cada aula                                         #
############################################################################
Vacancy.destroy_all
ClassRoomInstitute.all.each do |a|
  12.times {|i|
    Vacancy.create!([{class_room_institute_id: a.id, user_id: 1, occupant: nil, enabled: true}])
  }
end
p "[GIDAPPF] Creadas #{Vacancy.count} Vacantes" #requerido por cada aula

##########################################################################
# Períodos de prueba, arbitrariamente se crea un período actual, otro    #
# pasado y otro futuro. Tambien es arbitrario que sean las mismas        #
# comisiones por cada periodo, podrian ser distintas                     #
##########################################################################
TimeSheet.destroy_all
Commission.all.each do |a|
  TimeSheet.create!([
    {
      commission_id: a.id,
      start_date: 15.month.before,
      end_date: 3.month.before,
      enabled: true
    },{
      commission_id: a.id,
      start_date: Date.today,
      end_date: 13.month.after,
      enabled: true
    },{
      commission_id: a.id,
      start_date: 15.month.after,
      end_date: 28.month.after,
      enabled: false
    }
  ])
end  #requerido por cada comisión
p "[GIDAPPF] Creados #{TimeSheet.count} periodos"

###############################################################################
# Materias de prueba por cada aula, creadas a partir del array auxiliar.      #
###############################################################################
Matter.destroy_all
Matter.create!([
{
  name: "1Matem1",
  description: "Matemática Uno",
  trayect: "PRIMERO",
  enable: true
},{
  name: "2Matem2",
  description: "Matemática dos",
  trayect: "SEGUNDO",
  enable: true
},{
  name: "3Matem3",
  description: "Matemática tres",
  trayect: "TERCERO",
  enable: true
},{
  name: "4Leng1",
  description: "Lengua uno",
  trayect: "PRIMERO",
  enable: true
},{
  name: "5Leng2",
  description: "Lengua dos",
  trayect: "SEGUNDO",
  enable: true
},{
  name: "6Leng3",
  description: "Lengua tres",
  trayect: "TERCERO",
  enable: true
},{
  name: "7Hist1",
  description: "Historia uno",
  trayect: "PRIMERO",
  enable: true
},{
  name: "8Hist2",
  description: "Historia dos",
  trayect: "SEGUNDO",
  enable: true
},{
  name: "9geo1",
  description: "Geografia uno",
  trayect: "PRIMERO",
  enable: true
},{
  name: "10Geo2",
  description: "Geografia dos",
  trayect: "SEGUNDO",
  enable: true
},{
  name: "11Nat1",
  description: "Ciencias naturales uno",
  trayect: "PRIMERO",
  enable: true
},{
  name: "12Nat2",
  description: "Ciencias naturales dos",
  trayect: "SEGUNDO",
  enable: true
}
])
p "[GIDAPPF] Creados #{Matter.count} materias"

######################################################################
# Horarios de la comision inicial, es requerimiento de sistema.      #
# Cada vacante requiere un horario dentro del primer periodo.        #
# La comisión inicial existe para controlar la cantidad de vacantes  #
# es por eso que no importan los horarios ni el periodo.             #
######################################################################
TimeSheetHour.destroy_all
Vacancy.all.each do |a|
  TimeSheetHour.create!([
    {
      from_hour: 0, from_min: 0, to_hour: 0, to_min: 0,
      monday: true, tuesday: true, wednesday: true, thursday: true,
      friday: true, saturday: true, sunday: true,
      vacancy_id: a.id,
      time_sheet_id: TimeSheet.first.id,
      matter_id: Matter.first.id
    }
  ])
end #requerido por cada vacante de aula
p "[GIDAPPF] Creado #{TimeSheetHour.count} Horarios de ingresantes"

###########################################################################
# 1. Horarios de muestra turno manana y todas las vacantes aula 1.        #
###########################################################################
  Vacancy.where(class_room_institute_id: 1).each do |a|
    Commission.find(2).time_sheets.each do |p|
      TimeSheetHour.new(
        from_hour: 8, from_min: 0, to_hour: 9, to_min: 15,
        monday: true, tuesday: true, wednesday: true, thursday: true,
        friday: true, saturday: false, sunday: false,
        vacancy_id: a.id,
        time_sheet_id: p.id,
        matter_id: Matter.find_by(name: "1Matem1").id
      ).save
      TimeSheetHour.new(
        from_hour: 9, from_min: 30, to_hour: 10, to_min: 10,
        monday: true, tuesday: true, wednesday: true, thursday: true,
        friday: true, saturday: false, sunday: false,
        vacancy_id: a.id,
        time_sheet_id: p.id,
        matter_id: Matter.find_by(name: "4Leng1").id
      ).save
      TimeSheetHour.new(
        from_hour: 10, from_min: 20, to_hour: 12, to_min: 0,
        monday: true, tuesday: true, wednesday: true, thursday: true,
        friday: true, saturday: false, sunday: false,
        vacancy_id: a.id,
        time_sheet_id: p.id,
        matter_id: Matter.find_by(name: "7Hist1").id
      ).save
    end
  end

###########################################################################
# 2. Horarios de muestra turno manana y todas las vacantes aula 2.        #
###########################################################################
  Vacancy.where(class_room_institute_id: 2).each do |a|
    Commission.find(3).time_sheets.each do |p|
      TimeSheetHour.new(
        from_hour: 8, from_min: 0, to_hour: 9, to_min: 15,
        monday: true, tuesday: true, wednesday: true, thursday: true,
        friday: true, saturday: false, sunday: false,
        vacancy_id: a.id,
        time_sheet_id: p.id,
        matter_id: Matter.find_by(name: "4Leng1").id
      ).save
      TimeSheetHour.new(
        from_hour: 9, from_min: 30, to_hour: 10, to_min: 10,
        monday: true, tuesday: true, wednesday: true, thursday: true,
        friday: true, saturday: false, sunday: false,
        vacancy_id: a.id,
        time_sheet_id: p.id,
        matter_id: Matter.find_by(name: "7Hist1").id
      ).save
      TimeSheetHour.new(
        from_hour: 10, from_min: 20, to_hour: 12, to_min: 0,
        monday: true, tuesday: true, wednesday: true, thursday: true,
        friday: true, saturday: false, sunday: false,
        vacancy_id: a.id,
        time_sheet_id: p.id,
        matter_id: Matter.find_by(name: "1Matem1").id
      ).save
    end
  end

###########################################################################
# 3. Horarios de muestra turno manana y todas las vacantes aula 3.        #
###########################################################################
  Vacancy.where(class_room_institute_id: 3).each do |a|
    Commission.find(4).time_sheets.each do |p|
      TimeSheetHour.new(
        from_hour: 8, from_min: 0, to_hour: 9, to_min: 15,
        monday: true, tuesday: true, wednesday: true, thursday: true,
        friday: true, saturday: false, sunday: false,
        vacancy_id: a.id,
        time_sheet_id: p.id,
        matter_id: Matter.find_by(name: "2Matem2").id
      ).save
      TimeSheetHour.new(
        from_hour: 9, from_min: 30, to_hour: 10, to_min: 10,
        monday: true, tuesday: true, wednesday: true, thursday: true,
        friday: true, saturday: false, sunday: false,
        vacancy_id: a.id,
        time_sheet_id: p.id,
        matter_id: Matter.find_by(name: "5Leng2").id
      ).save
      TimeSheetHour.new(
        from_hour: 10, from_min: 20, to_hour: 12, to_min: 0,
        monday: true, tuesday: true, wednesday: true, thursday: true,
        friday: true, saturday: false, sunday: false,
        vacancy_id: a.id,
        time_sheet_id: p.id,
        matter_id: Matter.find_by(name: "8Hist2").id
      ).save
    end
  end

  ###########################################################################
  # 4. Horarios de muestra turno manana y todas las vacantes aula 4.        #
  ###########################################################################
    Vacancy.where(class_room_institute_id: 4).each do |a|
      Commission.find(5).time_sheets.each do |p|
        TimeSheetHour.new(
          from_hour: 8, from_min: 0, to_hour: 9, to_min: 15,
          monday: true, tuesday: true, wednesday: true, thursday: true,
          friday: true, saturday: false, sunday: false,
          vacancy_id: a.id,
          time_sheet_id: p.id,
          matter_id: Matter.find_by(name: "5Leng2").id
        ).save
        TimeSheetHour.new(
          from_hour: 9, from_min: 30, to_hour: 10, to_min: 10,
          monday: true, tuesday: true, wednesday: true, thursday: true,
          friday: true, saturday: false, sunday: false,
          vacancy_id: a.id,
          time_sheet_id: p.id,
          matter_id: Matter.find_by(name: "8Hist2").id
        ).save
        TimeSheetHour.new(
          from_hour: 10, from_min: 20, to_hour: 12, to_min: 0,
          monday: true, tuesday: true, wednesday: true, thursday: true,
          friday: true, saturday: false, sunday: false,
          vacancy_id: a.id,
          time_sheet_id: p.id,
          matter_id: Matter.find_by(name: "2Matem2").id
        ).save
      end
    end
  ###########################################################################
  # 5. Horarios de muestra turno manana y todas las vacantes aula 3.        #
  ###########################################################################
    Vacancy.where(class_room_institute_id: 3).each do |a|
      Commission.find(6).time_sheets.each do |p|
        TimeSheetHour.new(
          from_hour: 8, from_min: 0, to_hour: 9, to_min: 15,
          monday: true, tuesday: true, wednesday: true, thursday: true,
          friday: true, saturday: false, sunday: false,
          vacancy_id: a.id,
          time_sheet_id: p.id,
          matter_id: Matter.find_by(name: "2Matem2").id
        ).save
        TimeSheetHour.new(
          from_hour: 9, from_min: 30, to_hour: 10, to_min: 10,
          monday: true, tuesday: true, wednesday: true, thursday: true,
          friday: true, saturday: false, sunday: false,
          vacancy_id: a.id,
          time_sheet_id: p.id,
          matter_id: Matter.find_by(name: "5Leng2").id
        ).save
        TimeSheetHour.new(
          from_hour: 10, from_min: 20, to_hour: 12, to_min: 0,
          monday: true, tuesday: true, wednesday: true, thursday: true,
          friday: true, saturday: false, sunday: false,
          vacancy_id: a.id,
          time_sheet_id: p.id,
          matter_id: Matter.find_by(name: "8Hist2").id
        ).save
      end
    end

  ###########################################################################
  # 6. Horarios de muestra turno tarde y todas las vacantes aula 3.         #
  ###########################################################################
    Vacancy.where(class_room_institute_id: 3).each do |a|
      Commission.find(7).time_sheets.each do |p|
        TimeSheetHour.new(
          from_hour: 13, from_min: 0, to_hour: 14, to_min: 15,
          monday: true, tuesday: true, wednesday: true, thursday: true,
          friday: true, saturday: false, sunday: false,
          vacancy_id: a.id,
          time_sheet_id: p.id,
          matter_id: Matter.find_by(name: "5Leng2").id
        ).save
        TimeSheetHour.new(
          from_hour: 14, from_min: 20, to_hour: 15, to_min: 45,
          monday: true, tuesday: true, wednesday: true, thursday: true,
          friday: true, saturday: false, sunday: false,
          vacancy_id: a.id,
          time_sheet_id: p.id,
          matter_id: Matter.find_by(name: "2Matem2").id
        ).save
        TimeSheetHour.new(
          from_hour: 15, from_min: 50, to_hour: 17, to_min: 0,
          monday: true, tuesday: true, wednesday: true, thursday: true,
          friday: true, saturday: false, sunday: false,
          vacancy_id: a.id,
          time_sheet_id: p.id,
          matter_id: Matter.find_by(name: "5Leng2").id
        ).save
      end
    end

    ###########################################################################
    # 7. Horarios de muestra turno tarde y todas las vacantes aula 4.         #
    ###########################################################################
      Vacancy.where(class_room_institute_id: 4).each do |a|
        Commission.find(8).time_sheets.each do |p|
          TimeSheetHour.new(
            from_hour: 13, from_min: 0, to_hour: 14, to_min: 15,
            monday: true, tuesday: true, wednesday: true, thursday: true,
            friday: true, saturday: false, sunday: false,
            vacancy_id: a.id,
            time_sheet_id: p.id,
            matter_id: Matter.find_by(name: "5Leng2").id
          ).save
          TimeSheetHour.new(
            from_hour: 14, from_min: 20, to_hour: 15, to_min: 45,
            monday: true, tuesday: true, wednesday: true, thursday: true,
            friday: true, saturday: false, sunday: false,
            vacancy_id: a.id,
            time_sheet_id: p.id,
            matter_id: Matter.find_by(name: "2Matem2").id
          ).save
          TimeSheetHour.new(
            from_hour: 15, from_min: 50, to_hour: 17, to_min: 0,
            monday: true, tuesday: true, wednesday: true, thursday: true,
            friday: true, saturday: false, sunday: false,
            vacancy_id: a.id,
            time_sheet_id: p.id,
            matter_id: Matter.find_by(name: "5Leng2").id
          ).save
        end
      end

###########################################################################
# 8. Horarios de muestra turno tarde y todas las vacantes aula 1.         #
###########################################################################
  Vacancy.where(class_room_institute_id: 1).each do |a|
    Commission.find(9).time_sheets.each do |p|
      TimeSheetHour.new(
        from_hour: 17, from_min: 0, to_hour: 22, to_min: 0,
        monday: true, tuesday: true, wednesday: true, thursday: true,
        friday: true, saturday: false, sunday: false,
        vacancy_id: a.id,
        time_sheet_id: p.id,
        matter_id: Matter.find_by(name: "6Leng3").id
      ).save
    end
  end
p "[GIDAPPF] Creados #{TimeSheetHour.count} horarios de muestra"

###########################################################################
# 10 ingresantes de muestra turno mañana, minimo perfil                   #
###########################################################################
10.times do |u|
  u10 = User.new({email: "ingresante#{u}@gidappf.edu.ar", password: "ingresante#{u}", password_confirmation: "ingresante#{u}"})
  u10.save
  Usercommissionrole.new(
    role_id: Role.find_by(level: 10, enabled: false).id,
    user_id: u10.id, commission_id: 2
  ).save
  p10=Profile.new( name: "#{Profile.count+1}/#{u+1000000}", description: "A description user #{u}", valid_from: Date.today, valid_to: 1.year.after )
  User.find_by(email: LockEmail::LIST[1]).documents.first.profile.profile_keys.each do |i|
    x=i.id
    case x
      when 3 #dni si es la clave 3 de la plantilla
        p10.profile_keys.build(:key => i.key, :client_side_validator_id => i.client_side_validator_id).profile_values.build(:value => (u+1000000).to_s).save
      when 23 #"Se inscribe a cursar:"
        p10.profile_keys.build(:key => i.key, :client_side_validator_id => i.client_side_validator_id).profile_values.build(:value => "PRIMERO").save
      when 24 #'Elección de turno desde[Hr]:'
        p10.profile_keys.build(:key => i.key, :client_side_validator_id => i.client_side_validator_id).profile_values.build(:value => "8").save
      when 25 #'Elección de turno hasta[Hr]:'
        p10.profile_keys.build(:key => i.key, :client_side_validator_id => i.client_side_validator_id).profile_values.build(:value => "12").save
      else
        p10.profile_keys.build(:key => i.key, :client_side_validator_id => i.client_side_validator_id).profile_values.build(:value => nil).save
    end
  end
  Document.new(profile: p10, user: u10, input: Input.find_by(title: 'Admministrative rules')).save
end

###########################################################################
# 10 ingresantes de muestra turno tarde, minimo perfil                    #
###########################################################################
10.times do |u|
  u10 = User.new({email: "ingresante#{u+10}@gidappf.edu.ar", password: "ingresante#{u+10}", password_confirmation: "ingresante#{u+10}"})
  u10.save
  Usercommissionrole.new(
    role_id: Role.find_by(level: 10, enabled: false).id,
    user_id: u10.id, commission_id: Commission.first.id
  ).save
  p10=Profile.new( name: "#{Profile.count+1}/#{u+2000000}", description: "A description user #{u+10}", valid_from: Date.today, valid_to: 1.year.after )
  User.find_by(email: LockEmail::LIST[1]).documents.first.profile.profile_keys.each do |i|
    x=i.id
    case x
      when 3 #dni si es la clave 3 de la plantilla
        p10.profile_keys.build(:key => i.key, :client_side_validator_id => i.client_side_validator_id).profile_values.build(:value => (u+2000000).to_s).save
      when 23 #"Se inscribe a cursar:"
        p10.profile_keys.build(:key => i.key, :client_side_validator_id => i.client_side_validator_id).profile_values.build(:value => "Segundo").save
      when 24 #'Elección de turno desde[Hr]:'
        p10.profile_keys.build(:key => i.key, :client_side_validator_id => i.client_side_validator_id).profile_values.build(:value => "13").save
      when 25 #'Elección de turno hasta[Hr]:'
        p10.profile_keys.build(:key => i.key, :client_side_validator_id => i.client_side_validator_id).profile_values.build(:value => "17").save
      else
        p10.profile_keys.build(:key => i.key, :client_side_validator_id => i.client_side_validator_id).profile_values.build(:value => nil).save
    end
  end
  Document.new(profile: p10, user: u10, input: Input.find_by(title: 'Admministrative rules')).save
end

###########################################################################
# 5 ingresantes de muestra turno noche, minimo perfil                     #
###########################################################################
5.times do |u|
  u5 = User.new({email: "ingresante#{u+20}@gidappf.edu.ar", password: "ingresante#{u+20}", password_confirmation: "ingresante#{u+20}"})
  u5.save
  Usercommissionrole.new(
    role_id: Role.find_by(level: 10, enabled: false).id,
    user_id: u5.id, commission_id: Commission.first.id
  ).save
  p5=Profile.new( name: "#{Profile.count+1}/#{u+3000000}", description: "A description user #{u+20}", valid_from: Date.today, valid_to: 1.year.after )
  User.find_by(email: LockEmail::LIST[1]).documents.first.profile.profile_keys.each do |i|
    x=i.id
    case x
      when 3 #dni si es la clave 3 de la plantilla
        p5.profile_keys.build(:key => i.key, :client_side_validator_id => i.client_side_validator_id).profile_values.build(:value => (u+3000000).to_s).save
      when 23 #"Se inscribe a cursar:"
        p5.profile_keys.build(:key => i.key, :client_side_validator_id => i.client_side_validator_id).profile_values.build(:value => "primero").save
      when 24 #'Elección de turno desde[Hr]:'
        p5.profile_keys.build(:key => i.key, :client_side_validator_id => i.client_side_validator_id).profile_values.build(:value => "17").save
      when 25 #'Elección de turno hasta[Hr]:'
        p5.profile_keys.build(:key => i.key, :client_side_validator_id => i.client_side_validator_id).profile_values.build(:value => "22").save
      else
        p5.profile_keys.build(:key => i.key, :client_side_validator_id => i.client_side_validator_id).profile_values.build(:value => nil).save
    end
  end
  Document.new(profile: p5, user: u5, input: Input.find_by(title: 'Admministrative rules')).save
end

#######################################################################################
# 5 ingresantes de muestra turno con amplia disponibilidad, ya cursaron anteriormente #
#######################################################################################
5.times do |u|
  u5 = User.new({email: "ingresante#{u+25}@gidappf.edu.ar", password: "ingresante#{u+25}", password_confirmation: "ingresante#{u+25}"})
  u5.save
  Usercommissionrole.new(
    role_id: Role.find_by(level: 10, enabled: false).id,
    user_id: u5.id, commission_id: Commission.first.id
  ).save
  p5=Profile.new( name: "#{Profile.count+1}/#{u+4000000}", description: "A description user #{u+25}", valid_from: Date.today, valid_to: 1.year.after )
  User.find_by(email: LockEmail::LIST[1]).documents.first.profile.profile_keys.each do |i|
    x=i.id
    case x
      when 3 #dni si es la clave 3 de la plantilla
        p5.profile_keys.build(:key => i.key, :client_side_validator_id => i.client_side_validator_id).profile_values.build(:value => (u+4000000).to_s).save
      when 23 #"Se inscribe a cursar:"
        p5.profile_keys.build(:key => i.key, :client_side_validator_id => i.client_side_validator_id).profile_values.build(:value => "tercero").save
      when 24 #'Elección de turno desde[Hr]:'
        p5.profile_keys.build(:key => i.key, :client_side_validator_id => i.client_side_validator_id).profile_values.build(:value => "7").save
      when 25 #'Elección de turno hasta[Hr]:'
        p5.profile_keys.build(:key => i.key, :client_side_validator_id => i.client_side_validator_id).profile_values.build(:value => "22").save
      else
        p5.profile_keys.build(:key => i.key, :client_side_validator_id => i.client_side_validator_id).profile_values.build(:value => nil).save
    end
  end
  Document.new(profile: p5, user: u5, input: Input.find_by(title: 'Admministrative rules')).save
end

###########################################################################
# 5 estudiantes del periodo anterior, minimo perfil                       #
###########################################################################
5.times do |u|
  u5 = User.new({email: "estudiante#{u+30}@gidappf.edu.ar", password: "estudiante#{u+30}", password_confirmation: "estudiante#{u+30}"})
  u5.save
  Usercommissionrole.new(
    role_id: Role.find_by(level: 20, enabled: true).id,
    user_id: u5.id, commission_id: Commission.find_by(name: "C. noche").id
  ).save
  p5=Profile.new( name: "#{Profile.count+1}/#{u+5000000}", description: "A description user #{u+30}", valid_from: 15.month.before, valid_to: 5.month.before )
  User.find_by(email: LockEmail::LIST[1]).documents.first.profile.profile_keys.each do |i|
    x=i.id
    case x
      when 3 #dni si es la clave 3 de la plantilla
        p5.profile_keys.build(:key => i.key, :client_side_validator_id => i.client_side_validator_id).profile_values.build(:value => (u+5000000).to_s).save
      when 23 #"Se inscribe a cursar:"
        p5.profile_keys.build(:key => i.key, :client_side_validator_id => i.client_side_validator_id).profile_values.build(:value => "tercero").save
      when 24 #'Elección de turno desde[Hr]:'
        p5.profile_keys.build(:key => i.key, :client_side_validator_id => i.client_side_validator_id).profile_values.build(:value => "17").save
      when 25 #'Elección de turno hasta[Hr]:'
        p5.profile_keys.build(:key => i.key, :client_side_validator_id => i.client_side_validator_id).profile_values.build(:value => "22").save
      else
        p5.profile_keys.build(:key => i.key, :client_side_validator_id => i.client_side_validator_id).profile_values.build(:value => nil).save
    end
  end
  Document.new(profile: p5, user: u5, input: Input.find_by(title: 'Admministrative rules')).save
end

###########################################################################
# 1 docente por materia                                                   #
###########################################################################
Matter.all.each_with_index do |matter, index|
  u2 = User.new({email: "docente#{index+35}@gidappf.edu.ar", password: "docente#{index+35}", password_confirmation: "docente#{index+35}"})
  u2.save
  Usercommissionrole.new(
    role_id: Role.find_by(level: 29, enabled: false).id,
    user_id: u2.id, commission_id: Commission.first.id
  ).save
  Usercommissionrole.new(
    role_id: Role.find_by(level: 29, enabled: false).id,
    user_id: u2.id, commission_id: Commission.first.id
  ).save
  Usercommissionrole.new(
    role_id: Role.find_by(level: 29, enabled: false).id,
    user_id: u2.id, commission_id: Commission.first.id
  ).save
  p2=Profile.new( name: "#{Profile.count+1}/#{index+6000000}", description: "A Docent of matter #{matter.name},  description user #{index+35}", valid_from: Date.today, valid_to: 1.year.after  )
  User.find_by(email: LockEmail::LIST[2]).documents.first.profile.profile_keys.each do |i|
    x=i.id
    case x
      when 43 #dni si es la clave 43 de la plantilla
        p2.profile_keys.build(:key => i.key, :client_side_validator_id => i.client_side_validator_id).profile_values.build(:value => (index+6000000).to_s).save
      when 48 #'Materias'
        p2.profile_keys.build(:key => i.key, :client_side_validator_id => i.client_side_validator_id).profile_values.build(:value => matter.id.to_s).save
      when 49 #'Elección de turno desde[Hr]:'
        p2.profile_keys.build(:key => i.key, :client_side_validator_id => i.client_side_validator_id).profile_values.build(:value => "5").save
      when 50 #'Elección de turno hasta[Hr]:'
        p2.profile_keys.build(:key => i.key, :client_side_validator_id => i.client_side_validator_id).profile_values.build(:value => "23").save
      else
        p2.profile_keys.build(:key => i.key, :client_side_validator_id => i.client_side_validator_id).profile_values.build(:value => nil).save
    end
  end
  Document.new(profile: p2, user: u2, input: Input.find_by(title: 'Admministrative rules')).save
end

p "[GIDAPPF] Creados #{User.count} usuarios de muestra"

#########################################################################################
# Documentos 'Time sheet hour students list'                                            #
# Cualquier perfil obligatoriamente tiene asociado este documento sin restricciones de  #
# lectura. Los valores son referencias constantes para calculos estadisticos.           #
#########################################################################################
User.find_by(email: "docente35@gidappf.edu.ar").usercommissionroles.first.update(commission_id: 2)

Commission.find(2).time_sheets.where(end_date: Date.today .. 36.month.after, enabled:true).
  last.time_sheet_hours.pluck(:from_hour,:from_min, :to_hour,:to_min).uniq.each do |hour|
    in_each_hour=Input.new(
      title: 'Time sheet hour students list',
      summary: 'Un listado de horario iniciado',
      grouping: true,
      enable: true,
      author: User.find_by(email: 'secretary@gidappf.edu.ar').id
    )
    #Legajos:t[0] 	Vacantes:t[1] 	Presente:t[2]
    t=Input.where(title: 'Time sheet hour students list').first.info_keys
    leg=in_each_hour.info_keys.build(:key => t[0].key, :client_side_validator_id => t[0].client_side_validator_id)
    vac=in_each_hour.info_keys.build(:key => t[1].key, :client_side_validator_id => t[1].client_side_validator_id)
    pr=in_each_hour.info_keys.build(:key => t[2].key, :client_side_validator_id => t[2].client_side_validator_id)
    it_time_sheet_hour = Commission.find(2).time_sheets.where(end_date: Date.today .. 36.month.after, enabled:true).
      last.time_sheet_hours.where(from_hour: hour[0],from_min: hour[1], to_hour: hour[2],to_min: hour[3]).to_enum
    Profile.where(
      id: Document.where(user_id: User.where(id: Commission.find(2).usercommissionroles.pluck(:user_id))).distinct(:user_id).pluck(:profile_id)
    ).where('valid_from <= ?', Date.today).where('valid_to >= ?', Date.today).each do |p|
      leg.info_values.build(:value => p.id)
      vac.info_values.build(:value => it_time_sheet_hour.next.vacancy_id)
      pr.info_values.build(:value => "link")
    end
    leg.save
    vac.save
    pr.save
    Document.new(
      profile: User.find_by(email: "docent@gidappf.edu.ar").documents.first.profile,
      user: User.find_by(email: "docent@gidappf.edu.ar"),
      input: in_each_hour
    ).save
    in_each_hour.update(summary: "Materia:#{it_time_sheet_hour.first.matter.name}.")
end
