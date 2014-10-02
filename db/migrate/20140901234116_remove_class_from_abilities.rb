class RemoveClassFromAbilities < ActiveRecord::Migration
  def change
    remove_column :abilities, :class
  end
end
