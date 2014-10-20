class AddCostsToAbilitiesAndMonsters < ActiveRecord::Migration
  def change
    add_column :monsters, :mp_cost, :integer
    add_column :monsters, :gp_cost, :integer
    add_column :abilities, :mp_cost, :integer
    add_column :abilities, :gp_cost, :integer
    remove_column :abilities, :store_price
    remove_column :abilities, :price
  end
end
