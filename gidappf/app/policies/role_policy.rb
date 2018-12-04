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
     @user.email.eql?( 'john@example.com')
    # false
  end

  def destroy?
    # @user.role?("company.destroy", record.id) if @user.present?
    update?
  end

  def new?
    create?
  end

  def create?
    self.set_is_sysadmin
    # if @user.email === 'john@example.com' then true else @issysadmin end
    # if @user.email === 'john@example.com' then true else false end
    @user.email.eql?( 'john@example.com')||@issysadmin
  end

end
