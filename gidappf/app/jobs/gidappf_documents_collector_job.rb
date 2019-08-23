require 'gidappf_templates_tools'

class GidappfDocumentsCollectorJob < ApplicationJob
  queue_as :default

  discard_on ActiveJob::DeserializationError

  def perform(*args)
    if GidappfTemplatesTools.database_exists? then
      TimeSheet.where('end_date > ?',Date.today).each do |time_sheet|
        unless time_sheet.time_sheet_hours.empty?
          GidappfTemplatesTools.
            students_list_to_circulate_at_hour(time_sheet.time_sheet_hours.first)
        end
      end
    end
  end
  
end
