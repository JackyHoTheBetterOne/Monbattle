class MembersController < ApplicationController
  # before action :authenticate_user!
  before_action :find_member, except: [:create]

  def create
    # render text: params.to_s
    @member = Member.new member_params
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

  def find_member
    @member = Member.find params[:id]
  end

  def member_params
    params.require(:member).permit(:monster_id, :party_id)
  end

end
