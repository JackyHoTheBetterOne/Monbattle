class CreateAbilities < ActiveRecord::Migration
  def change
    create_table :abilities do |t|
      t.string :name
      t.integer :ap_cost
      t.integer :store_price
      t.string :type
      t.text :image_url
      t.integer :power_level
      t.integer :min_level
      t.string :class
      t.integer :price

      t.timestamps
    end
  end
end
