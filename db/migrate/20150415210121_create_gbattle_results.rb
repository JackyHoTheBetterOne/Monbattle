class CreateGbattleResults < ActiveRecord::Migration
  def change
    create_table :gbattle_results do |t|
      t.boolean :is_victory
      t.integer :battle_id
      t.integer :summoner_id
      t.integer :points

      t.timestamps
    end

    add_index :gbattle_results, :battle_id
    add_index :gbattle_results, :summoner_id
    add_column :summoners, :guild_points, :integer, default: 0 
    add_column :battle_levels, :guild, :boolean, default: false

  end
end
