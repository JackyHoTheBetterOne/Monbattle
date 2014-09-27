class AbilSocketsController < ApplicationController

  def create
    @abil_socket = AbilSocket.new abil_socket_params
    @abil_socket.save
    redirect_to abilities_path
  end

  def destroy
    @abil_socket = abil_socket.find params[:id]
    @abil_socket.destroy
    redirect_to abilities_path
  end

private

  def abil_socket_params
    params.require(:abil_socket).permit(:socket_num)
  end
end
