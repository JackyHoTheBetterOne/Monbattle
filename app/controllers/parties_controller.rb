class PartiesController < ApplicationController
  # before_action authenticate_user!
  before_action :find_party, except: [:create]

  def create
    @party = Party.new party_params
    @party.user = current_user
    if @party.save
      redirect_to admin_index_path, notice: "Created Party"
    else
      redirect_to admin_index_path, notice: "Failed"
    end
  end


  def edit
  end

  def update
    @party.update_attributes(party_params)
    if @party.save
      redirect_to admin_index_path, notice: "Changed"
    end
  end

  def destroy
  end

  private

  def find_party
    @party = Party.find params[:id]
  end

  def party_params
    params.require(:party).permit(:user_id, :name)
  end

end
