class PartiesController < ApplicationController
  # before_action authenticate_user!
  before_action :find_party, except: [:create]
  before_action :find_user

  def create
    # render text: params.to_s
    @party = Party.new party_params
    if @party.save
      redirect_to admin_index_path, notice: "Created Party"
    else
      render :new
    end
  end

  def edit
  end

  def show
    @member = Member.new
  end

  def update
    @party.update_attributes(party_params)
    if @party.save
      # @party.user.find_by_user_name(npc).blank? ? redirect_to @party, notice: "Changed" :
      redirect_to admin_index_path, notice: "Changed"
    end
  end

  def npc_show
    @member = Member.new
    render :npc_show
  end

  def destroy
  end

  private

  def find_user
    @user = User.find params[:user_id]
  end

  def find_party
    @party = Party.find params[:id]
  end

  def party_params
    params.require(:party).permit(:user_id, :name)
  end

end
