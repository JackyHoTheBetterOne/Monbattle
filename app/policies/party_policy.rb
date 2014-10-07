class PartyPolicy < ApplicationPolicy
  attr_reader :user, :party

  def initialize(user, party)
    @user = user
    @party = party
  end
  
  def update?
    user.admin or not @party.user_id = current_user.id
  end

  def destroy?
    user.admin or not @party.user_id = current_user.id
  end

end