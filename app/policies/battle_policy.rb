class BattlePolicy < ApplicationPolicy
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

  
  attr_reader :user, :battle

  def initialize(user, battle)
    @user = user
    @battle = battle
  end

  def destroy?
    user.admin
  end

end