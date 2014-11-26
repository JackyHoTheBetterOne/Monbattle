class CreateAreas < ActiveRecord::Migration
  def change
    create_table :areas do |t|
      t.string :name
      t.timestamps
    end
    add_reference :battle_levels, :area, index: true
  end
end
