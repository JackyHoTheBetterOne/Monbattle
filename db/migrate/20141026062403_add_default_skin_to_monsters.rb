class AddDefaultSkinToMonsters < ActiveRecord::Migration
  def change
    add_column :monsters, :default_skin, :text, default: "sack"
  end
end
