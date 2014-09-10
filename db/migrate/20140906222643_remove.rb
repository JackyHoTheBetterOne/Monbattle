class Remove < ActiveRecord::Migration
  def change
    remove_column :evolved_states, :evolve_lvl
  end
end
