class RolePolicy < ApplicationPolicy

  def index?
    # @user.companies.exists? if @user.present?
    true
  end

  def show?
    # @user.role?("company.show", record.id) if @user.present?
    true
  end

  def edit?
    update?
  end

  def update?
    # @user.role?("company.update", record.id) if @user.present?
    if @user.email === 'john@example.com' then true else false end
  end

  def destroy?
    # @user.role?("company.destroy", record.id) if @user.present?
    update?
  end

  def new?
    create?
  end

  def create?
    set_is_sysadmin
    if @user.email === 'john@example.com' then true else @issysadmin end
  end

  private
    def set_is_sysadmin
      begin
        my_record = Usercommissionrole.joins(:users).find_by(user: @user)
      rescue ActiveRecord::RecordNotFound => e
        my_record = nil
      end
      if my_record === nil then @issysadmin=true else @issysadmin=false end
    end

end
