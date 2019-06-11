
class GidappfStudentsListAbsencesJob < ApplicationJob
  queue_as :default

  discard_on ActiveJob::DeserializationError

#################################################################################################
# Documentos 'Time sheet hour students list'                                                    #
# GidappfStudentsListAbsencesJob.set wait_until: time_until_out).perform_later(time_sheet_hour) #
#################################################################################################
  def perform(*arg)
    nro=arg.first.to_i
    time_sheet_hour = TimeSheetHour.find(nro)
    unless time_sheet_hour.nil?
      # to_justify=Profile.where(
      #   id: Document.where(user_id: User.where(id: time_sheet_hour.time_sheet.commission.usercommissionroles.pluck(:user_id))).distinct(:user_id).pluck(:profile_id)
      # ).where('valid_from <= ?', Time.now).where('valid_to >= ?', Time.now)
      # presents=Vacancy.where(id: time_sheet_hour.time_sheet.time_sheet_hours.pluck(:vacancy_id))
      # presents.each do |v|
      #   unless v.occupant.nil?
      #     to_justify -= Profile.find(v.occupant.to_i)
      #     v.occupant=nil
      #   end
      # end
      # unless to_justify.empty?
      #   abscence=Input.new(
      #     title: 'Time sheet hour list absences',
      #     summary:"Materia:#{time_sheet_hour.matter.name}, fecha: #{time_sheet_hour.updated_at}, aula: #{time_sheet_hour.vacancy.class_room_institute.name}.",
      #     grouping: true,enable: true,author: Input.find_by(title: 'Time sheet hour list absences').author
      #   )
      #   #Legajo:t[0] 	Justificado:t[1] 'edit't[2] 'destroy't[3]
      #   t=Input.where(title: 'Time sheet hour list absences').first.info_keys
      #   leg=abscence.info_keys.build(:key => t[0].key, :client_side_validator_id => t[0].client_side_validator_id)
      #   jus=abscence.info_keys.build(:key => t[1].key, :client_side_validator_id => t[1].client_side_validator_id)
      #   edi=abscence.info_keys.build(:key => t[2].key, :client_side_validator_id => t[2].client_side_validator_id)
      #   des=abscence.info_keys.build(:key => t[3].key, :client_side_validator_id => t[3].client_side_validator_id)
      #   to_justify.each do |p|
      #     a=make_student_absence(p, time_sheet_hour)
      #     leg.info_values.build(:value => p.to_global_id )
      #     jus.info_values.build(:value => "No")
      #     edi.info_values.build(:value => a.to_global_id)
      #     des.info_values.build(:value => a.to_global_id)
      #   end
      #   leg.save
      #   jus.save
      #   edi.save
      #   des.save
      #   email=LockEmail::LIST[2]
      #   Document.new(
      #     profile: User.find_by(email: email).documents.first.profile,
      #     user: User.find_by(email:email),
      #     input: abscence
      #   ).save
      #   list=Input.find_by(
      #   title: 'Time sheet hour students list',
      #   summary:"Materia:#{time_sheet_hour.matter.name}, fecha: #{time_sheet_hour.created_at}, aula: #{time_sheet_hour.first.vacancy.class_room_institute.name}.",
      #   grouping: true,enable: true,
      #   author: Input.find_by(title: 'Time sheet hour students list').author).documents
      #   unless list.empty? || list.nil? || list.count != 1 then list.first.input_destroy end
      # end
      User.new({email: "a#{nro}@gidappf.edu.ar", password: "ause#{nro}", password_confirmation: "ause#{nro}"}).save
    end
  end

  def make_student_absence(profile, time_sheet_hour)
    u=profile.documents.first.user
    templale=Input.where(title: 'Student absence').first
    out=nil
    abscence=Input.new(
      title: template.title,
      summary: "#{template.summary} para: #{profile.name}, materia:#{time_sheet_hour.matter.name}.",
      grouping: template.grouping,
      enable: true,
      author: Profile.find_by(name: 'SecretaryProfile').id
    )
    template.info_keys.each do |t|
      abs_key=abscence.info_keys.build(:key => t.key, :client_side_validator_id => t.client_side_validator_id)
      if t.key.eql?('Horario:')
        abs_key.info_values.build(:value => time_sheet_hour.occupied_hour_fmt)
      end
      if t.key.eql?('Justificante:')
        abs_key.info_values.build(:value => "No recibido")
      end
      if t.key.eql?('Justificado:')
        abs_key.info_values.build(:value => "No")
      end
      if t.key.eql?('Minutos de incumplimiento:')
        abs_key.info_values.build(:value => (
          (time_sheet_hour.to_hour*60+time_sheet_hour.to_min)-(time_sheet_hour.from_hour*60+time_sheet_hour.from_min)
          ))
      end
      if t.key.eql?('Observaciones:')
        abs_key.info_values.build(:value => "Pendiente presentar justificación")
      end
      abs_key.save
    end
    abscence.save
    out=Document.new(
      profile: u.documents.first.profile,
      user: u,
      input: abscence
    )
    out.save
    out
  end

end
