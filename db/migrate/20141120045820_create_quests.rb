class CreateQuests < ActiveRecord::Migration
  def change
    create_table :quests do |t|
      t.string :name
      t.text :description
      t.string :type
      t.string :stat
      t.integer :requirement
      t.boolean :is_active, default: true
      t.string :bonus
      t.string :reward_type
      t.integer :reward_amount
      t.datetime :end_date
      t.datetime :refresh_date

      t.timestamps
    end
  end
end
