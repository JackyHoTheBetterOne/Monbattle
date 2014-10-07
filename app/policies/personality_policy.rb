class PersonalityPolicy < ApplicationPolicy
  attr_reader :user, :personality

  def initialize(user, personality)
    @user = user
    @personality = personality
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