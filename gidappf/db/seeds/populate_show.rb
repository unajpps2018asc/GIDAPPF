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
4.times {|i|
  e=[i+1,"estudiantes#{i+1}","Descripción nro. #{i+1} generada automáticamente"]
  aulas.push(e)
}
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

############################################################################
# Vacantes de Aulas                                                        #
############################################################################
Vacancy.destroy_all
ClassRoomInstitute.all.each do |a|
  12.times {|i|
    Vacancy.create!([{class_room_institute_id: a.id, user_id: 1, occupant: nil, enabled: true}])
  }
end
p "[GIDAPPF] Creadas #{Vacancy.count} Vacantes" #requerido por cada aula

##########################################################################
# Períodos de prueba                                                     #
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
end #requerido por cada vacante de aula
p "[GIDAPPF] Creado #{TimeSheetHour.count} Horarios de ingresantes"

###########################################################################
# 4 Horarios de muestra turno mañana, todos los períodos                  #
###########################################################################
Commission.where.not(id: 1).where.not(id: 4).where.not(id: 5).each do |c|
  Vacancy.all.each do |a|
    c.time_sheets.each do |p|
      TimeSheetHour.new(
        from_hour: 8, from_min: 0, to_hour: 9, to_min: 15,
        monday: true, tuesday: true, wednesday: true, thursday: true,
        friday: true, saturday: false, sunday: false,
        vacancy_id: a.id,
        time_sheet_id: p.id
      ).save
      TimeSheetHour.new(
        from_hour: 9, from_min: 30, to_hour: 10, to_min: 10,
        monday: true, tuesday: true, wednesday: true, thursday: true,
        friday: true, saturday: false, sunday: false,
        vacancy_id: a.id,
        time_sheet_id: p.id
      ).save
      TimeSheetHour.new(
        from_hour: 10, from_min: 20, to_hour: 12, to_min: 0,
        monday: true, tuesday: true, wednesday: true, thursday: true,
        friday: true, saturday: false, sunday: false,
        vacancy_id: a.id,
        time_sheet_id: p.id
      ).save
    end
  end
end
###########################################################################
# 4 Horarios de muestra turno tarde                                       #
###########################################################################
Commission.where.not(id: 1).where.not(id: 2).where.not(id: 3).each do |c|
  Vacancy.all.each do |a|
    c.time_sheets.each do |p|
      TimeSheetHour.new(
        from_hour: 13, from_min: 0, to_hour: 15, to_min: 15,
        monday: true, tuesday: true, wednesday: true, thursday: true,
        friday: true, saturday: false, sunday: false,
        vacancy_id: a.id,
        time_sheet_id: p.id
      ).save
      TimeSheetHour.new(
        from_hour: 15, from_min: 15, to_hour: 17, to_min: 0,
        monday: true, tuesday: true, wednesday: true, thursday: true,
        friday: true, saturday: false, sunday: false,
        vacancy_id: a.id,
        time_sheet_id: p.id
      ).save
    end
  end
end
p "[GIDAPPF] Creados #{TimeSheetHour.count} horarios de muestra"

###########################################################################
# 200 usuarios de muestra turno mañana                                    #
###########################################################################
10.times do |u|
  u200 = User.new({email: "ingresante#{u}@gidappf.edu.ar", password: "ingresante#{u}", password_confirmation: "ingresante#{u}"})
  u200.save
  Usercommissionrole.new(
    role_id: Role.find_by(level: 10, enabled: false).id,
    user_id: u200.id, commission_id: Commission.first.id
  ).save
  p200=Profile.new( name: (u+1000000).to_s, description: "A description user #{u}", valid_from: Date.today, valid_to: 1.year.after )
  User.find_by(email: LockEmail::LIST[1]).documents.first.profile.profile_keys.each do |i|
    x=i.id
    case x
      when 3 #dni si es la clave 3 de la plantilla
        p200.profile_keys.build(:key => i.key, :client_side_validator_id => i.client_side_validator_id).profile_values.build(:value => (u+1000000).to_s).save
      when 23 #"Se inscribe a cursar:"
        p200.profile_keys.build(:key => i.key, :client_side_validator_id => i.client_side_validator_id).profile_values.build(:value => "PRIMERO").save
      when 24 #'Elección de turno desde[Hr]:'
        p200.profile_keys.build(:key => i.key, :client_side_validator_id => i.client_side_validator_id).profile_values.build(:value => "8").save
      when 25 #'Elección de turno hasta[Hr]:'
        p200.profile_keys.build(:key => i.key, :client_side_validator_id => i.client_side_validator_id).profile_values.build(:value => "12").save
      else
        p200.profile_keys.build(:key => i.key, :client_side_validator_id => i.client_side_validator_id).profile_values.build(:value => nil).save
    end
  end
  Document.new(profile: p200, user: u200).save
end

###########################################################################
# 200 usuarios de muestra turno tarde                                     #
###########################################################################
10.times do |u|
  u200 = User.new({email: "ingresante#{u+10}@gidappf.edu.ar", password: "ingresante#{u+10}", password_confirmation: "ingresante#{u+10}"})
  u200.save
  Usercommissionrole.new(
    role_id: Role.find_by(level: 10, enabled: false).id,
    user_id: u200.id, commission_id: Commission.first.id
  ).save
  p200=Profile.new( name: (u+2000000).to_s, description: "A description user #{u+10}", valid_from: Date.today, valid_to: 1.year.after )
  User.find_by(email: LockEmail::LIST[1]).documents.first.profile.profile_keys.each do |i|
    x=i.id
    case x
      when 3 #dni si es la clave 3 de la plantilla
        p200.profile_keys.build(:key => i.key, :client_side_validator_id => i.client_side_validator_id).profile_values.build(:value => (u+2000000).to_s).save
      when 23 #"Se inscribe a cursar:"
        p200.profile_keys.build(:key => i.key, :client_side_validator_id => i.client_side_validator_id).profile_values.build(:value => "Segundo").save
      when 24 #'Elección de turno desde[Hr]:'
        p200.profile_keys.build(:key => i.key, :client_side_validator_id => i.client_side_validator_id).profile_values.build(:value => "13").save
      when 25 #'Elección de turno hasta[Hr]:'
        p200.profile_keys.build(:key => i.key, :client_side_validator_id => i.client_side_validator_id).profile_values.build(:value => "17").save
      else
        p200.profile_keys.build(:key => i.key, :client_side_validator_id => i.client_side_validator_id).profile_values.build(:value => nil).save
    end
  end
  Document.new(profile: p200, user: u200).save
end
p "[GIDAPPF] Creados #{User.count} usuarios de muestra"
