class MonsterSkinPolicy < ApplicationPolicy
  attr_reader :user, :monster_skin
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

  def initialize(user, monster_skin)
    @user = user
    @monster_skin = monster_skin
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