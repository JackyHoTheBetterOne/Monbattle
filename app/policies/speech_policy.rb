class ThoughtPolicy < ApplicationPolicy
  attr_reader :user, :thought

  def initialize(user, thought)
    @user = user
    @thought = thought
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