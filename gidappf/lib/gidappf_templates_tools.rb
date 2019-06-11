require 'sidekiq/api'

module GidappfTemplatesTools
#######################################################################################
# Implementa comparación entre arrays para saber si todos los elementos de list están #
# en reference.                                                                       #
# Prerequisitos:                                                                      #
#           1) reference not null.                                                    #
# Devolución: True si cada elemento de list está en reference.                        #
########################################################################################
  def self.compare_templates_do(list, reference)
    out = list.count >= reference.count
    if out then
      list.each do |e|
        unless reference.include?(e) then out=false end
      end
    end
    out
  end

######################################################################################
# Implementa la creacion de ActiveJobs para cada lista de estudiantes en su horario. #
# en reference.                                                                      #
# Prerequisitos:                                                                     #
#           1) time_sheet_hour sin componentes ActiveJobs.                           #
# Devolución: ActiveJobs creados para generar documentos Time sheet hour students    #
# list para cada inicio de clase del horario. Tambien ActiveJobs creados para generar#
# documentos Time sheet hour list absences al final de clase.                        #
######################################################################################
  def self.students_list_to_circulate_at_hour(time_sheet_hour)
    today= Date.today
    unless today > time_sheet_hour.time_sheet.end_date
      if today > time_sheet_hour.time_sheet.start_date
        s=today
      else
        s=time_sheet_hour.time_sheet.start_date.dup
      end
      e=time_sheet_hour.time_sheet.end_date.dup
      (Date.new(s.year, s.month, s.day) .. Date.new(e.year, e.month, e.day)).each do |current|
          if time_sheet_hour.sunday? && current.wday.eql?(0) then
            self.to_queue_sidekiq(current, time_sheet_hour)
          end
          if time_sheet_hour.monday && current.wday.eql?(1) then
            self.to_queue_sidekiq(current, time_sheet_hour)
          end
          if time_sheet_hour.tuesday && current.wday.eql?(2) then
            self.to_queue_sidekiq(current, time_sheet_hour)
          end
          if time_sheet_hour.wednesday && current.wday.eql?(3) then
            self.to_queue_sidekiq(current, time_sheet_hour)
          end
          if time_sheet_hour.thursday && current.wday.eql?(4) then
            self.to_queue_sidekiq(current, time_sheet_hour)
          end
          if time_sheet_hour.friday && current.wday.eql?(5) then
            to_queue_sidekiq(current, time_sheet_hour)
          end
          if time_sheet_hour.saturday && current.wday.eql?(6) then
            self.to_queue_sidekiq(current, time_sheet_hour)
          end
        end
    end
  end

  ######################################################################################
  # Metodo privado usado en self.students_list_to_circulate_at_hour(time_sheet_hour).  #
  ######################################################################################
  def self.to_queue_sidekiq(current, time_sheet_hour)
    time_until_in = Time.new(current.year.to_i,current.month.to_i,current.day.to_i, time_sheet_hour.from_hour.to_i, time_sheet_hour.from_min.to_i, 00)
    time_until_out = Time.new(current.year.to_i,current.month.to_i,current.day.to_i, time_sheet_hour.to_hour.to_i, time_sheet_hour.to_min.to_i, 00)
    GidappfStudentsListDealerJob.set(wait_until: time_until_in).perform_later(time_sheet_hour.id)
    GidappfStudentsListAbsencesJob.set(wait_until: time_until_out).perform_later(time_sheet_hour.id)
  end

  def self.database_exists?
    ActiveRecord::Base.connection
  rescue ActiveRecord::NoDatabaseError
    false
  else
    true
  end


end #module
