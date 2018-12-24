class SetsusersaccessController < ApplicationController

  def settings
    @usercommissionroles=Usercommissionrole.all
    @roleOpts=Role.all
  end

  def edit
  end

end
