class CreateBattles < ActiveRecord::Migration
  def change
    create_table :battles do |t|
      t.string :outcome
      t.references :user, index: true
      t.integer :reward

      t.timestamps
    end
  end
end
