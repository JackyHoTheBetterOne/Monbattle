class EffectPolicy < ApplicationPolicy
  attr_reader :user, :effect

  def initialize(user, effect)
    @user = user
    @effect = effect
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