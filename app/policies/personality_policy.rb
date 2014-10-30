class PersonalityPolicy < ApplicationPolicy
  attr_reader :user, :personality
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