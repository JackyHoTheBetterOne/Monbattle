class CutScenePolicy < ApplicationPolicy
  attr_reader :user, :cut_scene
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

  def initialize(user, cut_scene)
    @user = user
    @cut_scene = cut_scene
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