class AddDefaultsSummoners < ActiveRecord::Migration
  def change
    remove_column :summoners, :mp, :integer
    remove_column :summoners, :gp, :integer
    remove_column :summoners, :current_lvl, :integer
    remove_column :summoners, :current_exp, :integer
    add_column :summoners, :mp, :integer, default: 0
    add_column :summoners, :gp, :integer, default: 0
    add_column :summoners, :current_lvl, :integer, default: 1
    add_column :summoners, :current_exp, :integer, default: 0
  end
end
