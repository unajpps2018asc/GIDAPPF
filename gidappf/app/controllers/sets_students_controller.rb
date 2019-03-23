class SetsStudentsController < ApplicationController
  def change_commission
    # a = ProfileKey.where(key: 'Elección de turno hasta[Hr]:').where.not(profile: Profile.first)
    # a += ProfileKey.where(key: 'Elección de turno desde[Hr]:').where.not(profile: Profile.first)
    # a += ProfileKey.where(key: 'Se inscribe a cursar:').where.not(profile: Profile.first)
    # a.each do |e|
    #   k = e.key
    #   v=e.profile_values
    #   unless v.empty? || v.first.value.blank? then
    #     p "Perfil: #{e.profile.name} #{k} #{v.first.value}"
    @profiles_period = Profile.where.not(id: 1)
    @msg=''
    #   end
    # end
    @msg << start_period.to_s+'|'
    @msg << end_period.to_s+'|'
    # @msg << params[:def_period]
    @str_periods = []
    @comms_period = Commission.where(:start_date => start_period - 30  .. start_period + 30).where(:end_date => end_period - 30  .. end_period + 30)
    Commission.all.each do |cp|
      @str_periods << "#{cp.start_date.strftime('%d/%m/%Y')} ~ #{cp.end_date.strftime('%d/%m/%Y')}"
    end
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
