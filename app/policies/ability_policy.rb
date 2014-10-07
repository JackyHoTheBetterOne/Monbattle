class AbilityPolicy < ApplicationPolicy
  attr_reader :user, :ability

  def initialize(user, ability)
    @user = user
    @ability = ability
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