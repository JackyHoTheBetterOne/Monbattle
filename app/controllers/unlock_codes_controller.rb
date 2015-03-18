class UnlockCodesController < ApplicationController
  def unlock
    @user = current_user
    @unlock = UnlockCode.find_by_code(params[:code_entered])
    @object = @unlock.unlock(@user)

    render json: @object
  end
end
