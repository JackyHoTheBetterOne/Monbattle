class BattleLevelPolicy < ApplicationPolicy
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