class MembersController < ApplicationController
  def current
    unless params[:tsh_id].to_i.nil? then
      tsh = TimeSheetHour.find(params[:tsh_id].to_i)
      authorize tsh
      @profiles = Profile.where(id: Document.where(user:
         User.where(id: tsh.time_sheet.commission.usercommissionroles.
           where.not(id: current_user.usercommissionroles.ids).pluck(:user_id))
       ).pluck(:profile_id).uniq)
      authorize @profiles
    end
  end

  def report
    unless params[:tsh_id].to_i.nil? then
      tsh = TimeSheetHour.find(params[:tsh_id].to_i)
      authorize tsh
      @documents = []
      Profile.where(id: Document.where(user:
         User.where(id: tsh.time_sheet.commission.usercommissionroles.
           where.not(id: current_user.usercommissionroles.ids).pluck(:user_id))
      ).pluck(:profile_id).uniq).each do |profile|
       calif=Input.where(id: profile.documents.pluck(:input_id), title: "Student calification")
       abse=Input.where(id: profile.documents.pluck(:input_id), title: "Student absence")
       @documents << [profile, calif, abse]
      end
    end
  end

end
