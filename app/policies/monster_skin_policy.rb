class MonsterSkinPolicy < ApplicationPolicy
  attr_reader :user, :monster_skin

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