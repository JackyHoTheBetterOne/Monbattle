class CreateGuilds < ActiveRecord::Migration
  def change
    create_table :guilds do |t|
      t.string :name
      t.text :description
      t.integer :leader_id
      t.integer :capacity, default: 10

      t.timestamps
    end

    add_index :guilds, :leader_id
  end
end
