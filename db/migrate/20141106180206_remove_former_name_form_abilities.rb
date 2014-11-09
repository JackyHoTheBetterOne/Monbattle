class RemoveFormerNameFormAbilities < ActiveRecord::Migration
  def change
    remove_column :abilities, :former_name
  end
end
