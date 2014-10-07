class MonsterPolicy < ApplicationPolicy
  attr_reader :user, :monster

  def initialize(user, monster)
    @user = user
    @monster = monster
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