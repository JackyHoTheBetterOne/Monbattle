class CreateSummoners < ActiveRecord::Migration
  def change
    create_table :summoners do |t|
      t.string :name
      t.integer :current_lvl
      t.integer :current_exp
      t.references :user, index: true
      t.references :summoner_level, index: true

      t.timestamps
    end
  end
end
