class AreaPolicy < ApplicationPolicy
  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      if user.admin?
        scope.all
      else
        scope.where(:name => "")
      end
    end
  end


  attr_reader :user, :area

  def initialize(user, area)
    @user = user
    @area = area
  end

  def create?
    user.admin
  end

  def update?
    user.admin
  end

  def destroy?
    user.admin
  end

end