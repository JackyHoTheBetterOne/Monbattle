class PartiesController < ApplicationController
  # before_action authenticate_user!
  before_action :find_party, except: [:index, :create]
  before_action :find_user, except: [:create, :index]

  def index
    @party = Party.new
    @parties = Party.where(user_id: User.find_by_user_name("NPC").id)
    @battle_level = BattleLevel.new
    @battle_levels = BattleLevel.all
  end

  def create
    # render text: params.to_s
    @party = Party.new party_params
    if @party.save
      if @party.isNPC
        redirect_to parties_path, notice: "Success"
      else
        redirect_to admin_index_path, notice: "Created Party"
      end
    else
      render :new
    end
  end

  def edit
  end

  def show
    # render text: params.to_s
    @member = Member.new
  end

  def update
    @party.update_attributes(party_params)
    if @party.save
      if @party.isNPC
        redirect_to parties_path, notice: "Success"
      else
        redirect_to admin_index_path, notice: "Created Party"
      end
    else
      render :new
    end
  end

  def destroy
  end

  private

  def find_party
    @party = Party.find params[:id]
  end

  def find_user
    @user = @party.user
  end

  def party_params
    params.require(:party).permit(:user_id, :name)
  end

end
