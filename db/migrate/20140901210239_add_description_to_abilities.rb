class AddDescriptionToAbilities < ActiveRecord::Migration
  def change
    add_column :abilities, :description, :string
  end
end
