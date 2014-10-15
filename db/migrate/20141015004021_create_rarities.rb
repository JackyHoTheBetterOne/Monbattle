class CreateRarities < ActiveRecord::Migration
  def change
    create_table :rarities do |t|
      t.string :name

      t.timestamps
    end
  end
end
