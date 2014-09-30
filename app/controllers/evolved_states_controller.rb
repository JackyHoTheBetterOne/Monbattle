class EvolvedStatesController < ApplicationController
  # before_action :authenticate_user!
  before_action :find_evolved_state, only: [:destroy, :edit]

  def create
    @evolved_state = EvolvedState.new evolved_state_params
    if @evolved_state.save
      redirect_to admin_index_path, notice: "evolved_state saved"
    else 
      redirect_to admin_index_path, notice: "Failed!"
    end
  end

  def destroy
    if @evolved_state.destroy
      redirect_to admin_index_path, notice: "evolved_state Removed"
    else
      redirect_to admin_index_path, notice: "Failure"
    end
  end

  def edit
  end

  private

  def find_evolved_state
    @evolved_state = EvolvedState.find params[:id]
  end

  def evolved_state_params
    params.require(:evolved_state).permit(:name, :job_id, :element_id, :evolve_lvl, :created_from_id, :monster_id, :is_template,
     :monster_skin_id, :hp_modifier, :dmg_modifier)
  end
end
