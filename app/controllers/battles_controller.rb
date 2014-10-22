class BattlesController < ApplicationController
  before_action :find_battle, except: [:create, :index, :new, :generate_field]

  def index
    @battles = Battle.all
    @fights = Fight.all
  end

  def new
    @battle = Battle.new
    @user = current_user
    respond_to do |format|
      format.html {render :layout => "facebook_landing" if current_user.admin == false}
      format.js
    end
  end

  def create
    # render text: params.to_s
    @battle = Battle.new battle_params
    @user = current_user
    if @battle.save
      @battle.parties.push(Party.find_by_user_id(current_user.id))
      @battle.parties.push(
        Party.where(user: User.find_by_user_name("NPC")).
        where(name: @battle.battle_level.name).
        where(enemy: @user.email).last
        )
      redirect_to @battle, notice: "Battle Starting!"
    else
      render :new
    end
  end

  def show
    @user_party = @battle.parties[0]
    @pc_party   = @battle.parties[1]
    respond_to do |format|
      format.html { render layout: "facebook_landing" if current_user.admin == false }
      format.json { render json: @battle.build_json  }
    end
  end

  def update
    @battle.outcome = "complete"
    if @battle.save
      BattleReward.new(winner_id: winner_id, loser_id: loser_id, npc_id: npc_id, winning_summoner: @winning_summoner,
                      gp_reward: @battle.battle_level.mp_reward, mp_reward: @battle.battle_level.mp_reward)
      #redirect somewhere
    else
      #raise_expection
      #redirect somewhere
    end
  end

    # BattleReward.new(winner_id: 1, loser_id: 2, npc_id: 2, winning_summoner: s,
    #                   gp_reward: 100, mp_reward: 100)

    class BattleReward
      attr_reader :winner_id, :loser_id, :npc_id, :mp_reward, :gp_reward, :winning_summoner

      def initialize(args)
        @winner_id        = args[:winner_id]
        @loser_id         = args[:loser_id]
        @npc_id           = args[:npc_id]
        @mp_reward        = args[:mp_reward]
        @gp_reward        = args[:gp_reward]
        @winning_summoner = args[:winning_summoner]

        self.winner
      end

      def winner
        if @winner_id == npc_id
        else
          self.reward
        end
      end

      def reward
        @winning_summoner.mp += mp_reward
        @winning_summoner.gp += gp_reward
        @winning_summoner.save
      end

    end

  def destroy
    if @battle.destroy
      redirect_to battles_path, notice: "Destroyed"
    end
  end

  def generate_field
    @user = current_user
    Party.generate(@user)
    respond_to do |format|
      format.js
    end
  end

  private

  def battle_params
    params.require(:battle).permit(:outcome, :battle_level_id)
  end

  def find_battle
    @battle = Battle.find params[:id]
    @battle.parties = @battle.parties.order(:npc)
  end

end

