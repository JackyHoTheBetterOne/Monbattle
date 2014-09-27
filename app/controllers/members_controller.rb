class MembersController < ApplicationController
  # before_action :find_user
  before_action :find_party
  before_action :find_monster
  before_action :find_member, only: [:destroy]

  def create
    @member = @monster.members.new member_params
    respond_to do |format|
      if @member.save
        format.js { render :action }
        format.html { redirect_to @party, notice: "Monster Added to Party!" }
      else
        redirect_to @party, notice: "You fail!"
      end
    end
  end

  def destroy
    respond_to do |format|
      if @member.destroy
        format.html { redirect_to @party, notice: "Monster Removed From Team" }
        format.js { render :action }
      else
        redirect_to @party, notice: "You fail!"
      end
    end
  end

  private

  def find_party
    @party = Party.find params[:member][:party_id]
  end

  # def find_user
  #   @user = @party.user
  # end

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
