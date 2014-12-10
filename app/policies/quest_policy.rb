class QuestPolicy < ApplicationPolicy
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
        scope.where(:name => "")
      end
    end
  end


  attr_reader :user, :quest

  def initialize(user, quest)
    @user = user
    @quest = quest
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