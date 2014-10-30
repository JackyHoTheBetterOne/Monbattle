class ThoughtPolicy < ApplicationPolicy
  attr_reader :user, :thought
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