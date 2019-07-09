class MembersController < ApplicationController
  def current
    tsh = TimeSheetHour.find(params[:tsh_id].to_i)
    @profiles = Profile.where(id: Document.where(user:
      User.where(id: Usercommissionrole.where.not(id:
        current_user.usercommissionroles.ids).where(commission:
          tsh.time_sheet.commission).ids)).pluck(:profile_id))
    authorize @profiles
  end
end
