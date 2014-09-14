class MembersController < ApplicationController
  # before action :authenticate_user!
  before_action :find_monster, only: [:create]
  before_action :find_member, only: [:destroy]

  def create
    @member = @monster.members.new member_params
    if @member.save
      redirect_to admin_index_path, notice: "Monster Added to Team!"
    else
      redirect_to admin_index_path, notice: "You fail!"
    end
  end

  def destroy
    if @member.destroy
      redirect_to admin_index_path, notice: "Monster Removed From Team"
    else
      redirect_to admin_index_path, notice: "You fail!"
    end
  end

  private

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
