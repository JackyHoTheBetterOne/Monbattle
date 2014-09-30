class AddDamageToEffects < ActiveRecord::Migration
  def change
    add_column :effects, :damage, :integer
  end
end
