class RemoveAttributeFromEffects < ActiveRecord::Migration
  def change
    remove_column :effects, :attribute, :string
  end
end
