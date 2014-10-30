class MonsterPolicy < ApplicationPolicy
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

  attr_reader :user, :monster

  def initialize(user, monster)
    @user = user
    @monster = monster
  end

  def index?
    user.admin
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