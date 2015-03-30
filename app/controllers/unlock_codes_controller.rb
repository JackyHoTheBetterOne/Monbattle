class UnlockCodesController < ApplicationController
  def unlock
    @user = current_user
    @unlock = UnlockCode.find_by_code(params[:code_entered])
    unlocky = User::CodyUnlocky.new(user: @user, code: @unlock)
    unlocky.call

    @result = unlocky.result
    render json: @result
  end

  def unlock_by_username
    params[:code_ids].each do |c|
      @user = current_user
      @unlock = UnlockCode.find(params[:code_id])
      if current_user.user_name == @unlock.user_name
        @object = User::CodyUnlocky.new(user: @user, code: @unlock)
        @object.call
      end
    end

    render nothing: true
  end
end
