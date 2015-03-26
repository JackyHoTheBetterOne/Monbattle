class UnlockCodesController < ApplicationController
  def unlock
    @user = current_user
    @unlock = UnlockCode.find_by_code(params[:code_entered])
    @object = @unlock.unlock(@user)

    render template: "unlock_code_reward", :layout => false
  end

  def unlock_by_username
    params[:code_ids].each do |c|
      @user = current_user
      @unlock = UnlockCode.find(params[:code_id])
      if current_user.user_name == @unlock.user_name
        @object = @unlock.unlock(@user)
      end
    end

    render nothing: true
  end
end
