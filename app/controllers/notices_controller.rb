class NoticesController < ApplicationController
  before_action :find_notice, only: [:update, :destroy]

  def index
    @notices = policy_scope(Notice.all.order("created_at DESC").limit(20))
    @notice = Notice.new
  end

  def create
    authorize @notice
    @notice = Notice.new(notice_params)
    respond_to do |format|
      if @notice.save
        format.js
      else
        format.js
      end
    end
  end

  def update
    authorize @notice
    @notice.update_attributes(notice_params)
    respond_to do |format|
      if @notice.save
        format.js
      else
        format.js
      end
    end
  end

  def destroy
    authorize @notice
    if @notice.destroy
      respond_to do |format|
        format.js { render }
      end
    end
  end

  private
  def notice_params
    params.require(:notice).permit(:title, :body, :notice_type_id)
  end

  def find_notice
    @notice = Notice.find(params[:id])
  end

end
