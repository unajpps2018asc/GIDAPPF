
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
    to_justify=[]
    if is_ausentable_time_sheet_hour?(time_sheet_hour) then
      to_justify=Profile.where(id: Document.where(user_id: User.where(id: time_sheet_hour.time_sheet.commission.usercommissionroles.pluck(:user_id))).pluck(:profile_id)).where('valid_from <= ?', Time.now).where('valid_to >= ?', Time.now).to_ary
      Vacancy.where(id: time_sheet_hour.time_sheet.time_sheet_hours.pluck(:vacancy_id)).each do |v|
        unless v.occupant.nil?
          to_justify -= [Profile.find(v.occupant)]
          v.update(occupant: nil)
        end
      end
      unless to_justify.empty?
        absences=Input.new(
          title: 'Time sheet hour list absences',
          summary:"Materia:#{time_sheet_hour.matter.name}, fecha: #{time_sheet_hour.updated_at}, aula: #{time_sheet_hour.vacancy.class_room_institute.name}.",
          grouping: true,enable: true,author: Input.find_by(title: 'Time sheet hour list absences').author.to_i
        )
        #Legajo:t[0]GIDAPPF links 	Justificado:t[1]'GIDAPPF read only Acta:t[2]GIDAPPF links
        t=Input.where(title: 'Time sheet hour list absences').first.info_keys.order(:id)
        leg=absences.info_keys.build(:key => t[0].key, :client_side_validator_id => t[0].client_side_validator_id, :attrib_id => t[0].attrib_id)
        jus=absences.info_keys.build(:key => t[1].key, :client_side_validator_id => t[1].client_side_validator_id, :attrib_id => t[1].attrib_id)
        edi=absences.info_keys.build(:key => t[2].key, :client_side_validator_id => t[2].client_side_validator_id, :attrib_id => t[2].attrib_id)
        to_justify.each do |p|
          doc=make_student_absence(p, time_sheet_hour)
          leg.info_values.build(:value => p.to_global_id)
          jus.info_values.build(:value => "No")
          edi.info_values.build(:value => doc.to_global_id)
        end
        absences.save
        Document.new(
          profile_id: User.find_by(email: LockEmail::LIST[2]).documents.first.profile_id,
          user_id: User.find_by(email: LockEmail::LIST[2]).id,
          input_id: absences.id
        ).save
        old_list=Input.find_by(
          title: 'Time sheet hour students list',
          summary:"Materia:#{time_sheet_hour.matter.name}, fecha: #{time_sheet_hour.created_at}, aula: #{time_sheet_hour.vacancy.class_room_institute.name}.",
          grouping: true, enable: true)
        unless old_list.nil? || old_list.documents.nil? || old_list.documents.empty? || old_list.documents.count > 1 then
          old_list.documents.first.input_destroy
        end
      end
    end
  end

  def make_student_absence(profile, time_sheet_hour)
    out=nil
    u=profile.documents.first.user
    template=Input.where(title: 'Student absence').first
    absence=Input.new(
      title: template.title,
      summary: "#{template.summary} para: #{profile.name}, materia:#{time_sheet_hour.matter.name}, Día:#{ Date.today.to_s}.",
      grouping: template.grouping,
      enable: true,
      author: Profile.find_by(name: 'SecretaryProfile').id
    )
    template.info_keys.each do |t|
      abs_key=absence.info_keys.build(:key => t.key, :client_side_validator_id => t.client_side_validator_id, :attrib_id => t.attrib_id)
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
    absence.save
    out=Document.new(
      profile_id: u.documents.first.profile_id,
      user_id: u.id,
      input_id: absence.id
    )
    out.save
    out.input
  end

  private

  def is_ausentable_time_sheet_hour?(time_sheet_hour)
    out =false
    unless time_sheet_hour.nil? || time_sheet_hour.time_sheet.commission.usercommissionroles.empty?
      leads = time_sheet_hour.time_sheet.commission.usercommissionroles.where(role_id: Role.where('level > ?', 20.0).ids)
    end
    unless leads.nil? || leads.empty? then out = leads.count > 0 end
    out
  end

end
