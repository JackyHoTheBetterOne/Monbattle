class BattlesController < ApplicationController
  # before_action :authenticate_user!
  before_action :find_battle, except: [:create, :index]

  def index
  end

  def create
    # render text: params.to_s
    @battle = Battle.new battle_params
    # @battle.users.push(current_user, User.find_by_user_name("NPC"))
    if @battle.save
      @battle.users.push(current_user, User.find_by_user_name("NPC"))
      redirect_to @battle, notice: "Battle Starting!"
    else
      render :new
    end
  end

  def show
    respond_to do |format|
      format.html
      format.json { render json: @battle.as_json }
    end
  end

  def edit
  end

  def update
    #update victory status at end of battle
  end

  def destroy
    if @battle.destroy
      redirect_to admin_index_path, notice: "Destroyed"
    end
  end

  private

  def battle_params
    params.require(:battle).permit(:outcome, :battle_level_id)#{user_ids: []}
  end

  def find_battle
    @battle = Battle.find params[:id]
  end

end
