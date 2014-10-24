class AddSlugToBattles < ActiveRecord::Migration
  def change
    add_column :battles, :slug, :string
    add_index :battles, :slug, unique: true
  end
end
