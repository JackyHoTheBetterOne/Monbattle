class CreateBattleLevels < ActiveRecord::Migration
  def change
    create_table :battle_levels do |t|
      t.string :item_given
      t.integer :exp_given

      t.timestamps
    end
  end
end
