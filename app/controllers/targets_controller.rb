class TargetsController < ApplicationController
  # before action :authenticate!

  def create
    @target = Target.new target_params
    @target.save
    redirect_to admin_index_path
  end

  def destroy
    @target = Target.find params[:id]
    @target.destroy
    redirect_to admin_index_path
  end

private

  def target_params
    params.require(:target).permit(:name)
  end
end
