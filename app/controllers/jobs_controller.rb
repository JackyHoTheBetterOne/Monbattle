class JobsController < ApplicationController
  # before action :authenticate!

  def create
    @job = Job.new job_params
    @job.save
    redirect_to admin_index_path
  end

  def destroy
    @job = Job.find params[:id]
    @job.destroy
    redirect_to admin_index_path
  end

private

  def job_params
    params.require(:job).permit(:name, :evolve_lvl)
  end

end

  
