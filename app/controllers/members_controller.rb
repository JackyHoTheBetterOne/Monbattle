class MembersController < ApplicationController
  before_action :find_party
  before_action :find_user
  before_action :find_monster, only: [:create]
  before_action :find_member, only: [:destroy]

  def create
    @member = @monster.members.new member_params
    if @member.save
      if @user.user_name == "NPC"
        redirect_to @party, notice: "Monster Added to Stage"
      else
        redirect_to @party, notice: "Monster Added to Team!"
      end
    else
      redirect_to @party, notice: "You fail!"
    end
  end

  def destroy
    if @member.destroy
      if @user.user_name == "NPC"
        redirect_to @party, notice: "Monster Removed from Party!"
      else
        redirect_to @party, notice: "Monster Removed From Team"
      end
    else
      redirect_to @party, notice: "You fail!"
    end
  end

  private

  def find_party
    @party = Party.find params[:member][:party_id]
  end

  def find_user
    @user = @party.user
  end

  def find_monster
    @monster = Monster.find params[:monster_id]
  end

  def find_member
    @member = Member.find params[:id]
  end

  def member_params
    params.require(:member).permit(:monster_id, :party_id)
  end

end
