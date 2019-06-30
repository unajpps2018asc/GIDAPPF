class GidappfStudentsListDealerJob < ApplicationJob
  queue_as :default

  discard_on ActiveJob::DeserializationError

##############################################################################################
# Documentos 'Time sheet hour students list'                                                 #
# GidappfStudentsListDealerJob.set(wait_until: time_until_in).perform_later(time_sheet_hour) #
##############################################################################################
  def perform(*arg)
    nro=arg.first.to_i
    time_sheet_hour = TimeSheetHour.find(nro)
    if is_listable_time_sheet_hour?(time_sheet_hour)
      docent_profile=User.find(time_sheet_hour.time_sheet.commission.usercommissionroles.find_by(role: Role.where(level: 29.0)).user_id).documents.first.profile
      in_each_hour=Input.new(
        title: 'Time sheet hour students list',
        summary:"Materia:#{time_sheet_hour.matter.name}, fecha: #{time_sheet_hour.created_at}, aula: #{time_sheet_hour.vacancy.class_room_institute.name}.",
        grouping: true,enable: true,
        author: docent_profile.id
      )
      #Legajos:t[0] 	Vacantes:t[1] 	Presente:t[2]
      t=Input.where(title: 'Time sheet hour students list').first.info_keys
      leg=in_each_hour.info_keys.build(:key => t[0].key, :client_side_validator_id => t[0].client_side_validator_id)
      vac=in_each_hour.info_keys.build(:key => t[1].key, :client_side_validator_id => t[1].client_side_validator_id)
      pr=in_each_hour.info_keys.build(:key => t[2].key, :client_side_validator_id => t[2].client_side_validator_id)
      it_time_sheet_hour = time_sheet_hour.time_sheet.time_sheet_hours.where(
        from_hour: time_sheet_hour.from_hour,from_min: time_sheet_hour.from_min, to_hour: time_sheet_hour.to_hour,to_min: time_sheet_hour.to_min).to_enum
      Profile.where(
        id: Document.where(user_id: User.where(id: time_sheet_hour.time_sheet.commission.usercommissionroles.pluck(:user_id))).distinct(:user_id).pluck(:profile_id)
      ).where('valid_from <= ?', Date.today).where('valid_to >= ?', Date.today).each do |p|
        if p.listable?
          leg.info_values.build(:value => p.to_global_id )
          vac.info_values.build(:value => it_time_sheet_hour.next.vacancy_id.to_s)
          pr.info_values.build(:value => "No")
        end
      end
      in_each_hour.save
      docent=User.find(time_sheet_hour.time_sheet.commission.usercommissionroles.find_by(role: Role.where(level: 29.0)).user_id)
      Document.new(profile: docent_profile, user: docent, input: in_each_hour).save
    end
  end

  private

  def is_listable_time_sheet_hour?(time_sheet_hour)
    !time_sheet_hour.nil? &&
    !time_sheet_hour.time_sheet.commission.usercommissionroles.find_by(role: Role.where(level: 29.0)).nil? &&
    !User.find(time_sheet_hour.time_sheet.commission.usercommissionroles.find_by(role: Role.where(level: 29.0)).user_id).documents.nil?
  end

end
