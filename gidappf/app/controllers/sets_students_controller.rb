class SetsStudentsController < ApplicationController
  def change_commission
    @opt_periods = []
    @per_time_categ_profiles = []
    TimeSheet.all.each do |cp|
      @opt_periods << "#{cp.start_date.strftime('%d/%m/%Y')} ~ #{cp.end_date.strftime('%d/%m/%Y')}"
    end
    to_course = []
    ProfileKey.where.not(profile: Profile.first).find_each do |e|
      if e.key.eql?(ProfileKey.find(23).key) then # "Se inscribe a cursar:"
        unless e.profile_values.empty? then to_course << e.profile_values.first.value.upcase! end
      end
    end
    to_course.uniq.each do |trayect|
      TimeSheetHour.where.not(time_sheet: Commission.first.time_sheets.first).pluck(:from_hour,:from_min, :to_hour, :to_min).uniq.each do |time_categ|
        profiles_time_cat = ["#{trayect} #{time_categ[0]}:#{time_categ[1]} ~ #{time_categ[2]}:#{time_categ[3]}"]
        ProfileKey.where(key: ProfileKey.find(24).key).where.not(profile: Profile.first).each do |e| #'Elección de turno desde[Hr]:'
          unless e.profile_values.empty? || e.profile_values.first.value.blank? then
            if e.key.eql?(ProfileKey.find(24).key) && e.profile_values.first.value.to_i*60 >= time_categ[0]*60+time_categ[1] && e.profile.valid_to >= Date.today &&
              e.profile.profile_keys.find_by(key:ProfileKey.find(25).key).profile_values.first.value.to_i*60 <= time_categ[2]*60+time_categ[3] && #'Elección de turno hasta[Hr]:'
              !e.profile.profile_keys.find_by(key:ProfileKey.find(23).key).profile_values.empty? then
                if e.profile.profile_keys.find_by(key:ProfileKey.find(23).key).profile_values.first.value.upcase!.eql?(trayect) then
                  profiles_time_cat << e.profile
                end
            end
          end
        end
        unless profiles_time_cat.count == 1 then  @per_time_categ_profiles << profiles_time_cat end
      end
    end
    @profiles_period = Profile.where.not(id: Profile.first.id)
    @comms_period = TimeSheet.where.not(commission: Commission.first).where(
      :start_date => start_period - 30  .. start_period + 30).where(:end_date => end_period - 30  .. end_period + 30)
  end

  def selected_commission
  end

  private
    def start_period
      out = nil
      if params[:def_period].nil? then out=Commission.last.start_date
      else
        strfetch = params[:def_period].split('~')[0]
        out = DateTime.new(strfetch.split('/')[2].to_i,strfetch.split('/')[1].to_i,
                strfetch.split('/')[0].to_i)
      end
      out
    end

    def end_period
      out = nil
      if params[:def_period].nil? then out=Commission.last.end_date
      else
        strfetch = params[:def_period].split('~')[1]
        out = DateTime.new(strfetch.split('/')[2].to_i,strfetch.split('/')[1].to_i,
                strfetch.split('/')[0].to_i)
      end
      out
    end
end
