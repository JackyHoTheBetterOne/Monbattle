class CreateScores < ActiveRecord::Migration
  def change
    create_table :scores do |t|
      t.integer :points
      t.text    :code
      t.integer :battle_level_id
      t.integer :scorapable_id
      t.integer :scorapable_type
      t.timestamps
    end
    add_index :scores, :scorapable_id
    add_index :scores, :code
  end
end
