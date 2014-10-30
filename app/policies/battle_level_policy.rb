class BattleLevelPolicy < ApplicationPolicy
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
        scope.where(:id => "a")
      end
    end
  end
  
  attr_reader :user, :battle_level

  def initialize(user, battle_level)
    @user = user
    @battle_level = battle_level
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