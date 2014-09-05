class CreateSummonerLevels < ActiveRecord::Migration
  def change
    create_table :summoner_levels do |t|
      t.integer :lvl
      t.integer :exp_to_nxt_lvl
      t.integer :ap
      t.integer :monsters_allowed

      t.timestamps
    end
  end
end
