class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    false
  end

  def show?
    false
  end

  def create?
    false
  end

  def new?
    create?
  end

  def update?
    false
  end

  def edit?
    update?
  end

  def destroy?
    false
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope.all
    end
  end

  protected

    def set_is_sysadmin
      begin
        my_record = Usercommissionrole.joins(:user).find_by(user: @user)
      rescue ActiveRecord::RecordNotFound => e
        my_record = nil
      end
      if my_record === nil then @issysadmin=true else @issysadmin=false end
    end

end
