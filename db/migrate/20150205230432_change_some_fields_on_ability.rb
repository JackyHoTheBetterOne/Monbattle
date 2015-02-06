class ChangeSomeFieldsOnAbility < ActiveRecord::Migration
  def change
    remove_column :abilities, :mp_cost
    remove_column :abilities, :gp_cost
    add_column :abilities, :minimum, :integer
    add_column :abilities, :maximum, :integer
  end
end
