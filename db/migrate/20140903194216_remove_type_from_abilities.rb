class RemoveTypeFromAbilities < ActiveRecord::Migration
  def change
    remove_column :abilities, :type, :string
  end
end
