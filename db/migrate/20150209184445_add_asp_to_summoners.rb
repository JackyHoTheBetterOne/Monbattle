class AddAspToSummoners < ActiveRecord::Migration
  def change
    add_column :summoners, :asp, :integer, default: 0
    add_column :monsters, :asp_cost, :integer, default: 10
    remove_column :monsters, :mp_cost
    remove_column :monsters, :gp_cost
  end
end
