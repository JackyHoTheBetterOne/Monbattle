class StatTargetsController < ApplicationController
    # before action :authenticate!

  def create
    @stat_target = StatTarget.new stat_target_params
    @stat_target.save
    redirect_to admin_index_path
  end

  def destroy
    @stat_target = StatTarget.find params[:id]
    @stat_target.destroy
    redirect_to admin_index_path
  end

private

  def stat_target_params
    params.require(:stat_target).permit(:name)
  end
end
