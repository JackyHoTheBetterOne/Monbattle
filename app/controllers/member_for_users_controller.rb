class MemberForUsersController < ApplicationController
  before_action :find_user
  before_action :find_party
  before_action :find_monster_unlock
  before_action :find_base_mons
  before_action :find_members
  before_action :find_portrait_destroy, only: [:destroy]
  before_action :find_member, only: [:destroy]

  def create
    @member = @monster_unlock.members.new member_params
    @member.party = @party
    respond_to do |format|
      if @member.save
        format.js { render }
      else
        # redirect_to @party, notice: "You fail!"
      end
    end
  end

  def destroy
    respond_to do |format|
      if @member.destroy
        format.js { render }
      else
        # redirect_to @party, notice: "You fail!"
      end
    end
  end

  private

  def find_user
    @user = User.find params[:member][:user_id]
  end

  def find_party
    @party = @user.parties.first
  end

  def find_member
    @member = Member.find params[:id]
  end

  def find_portrait_destroy
    @portrait_destroy = params[:member][:portrait_destroy]
  end

  def find_base_mons
    @base_mons = MonsterUnlock.base_mons(@user)
  end

  def find_monster_unlock
    @monster_unlock = MonsterUnlock.find params[:monster_unlock_id]
  end

  def member_params
    params.require(:member).permit(:monster_unlock_id, :party_id)
  end

  def find_members
    @members = @party.members
  end

end
