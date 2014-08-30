class CreateEffects < ActiveRecord::Migration
  def change
    create_table :effects do |t|
      t.string :name
      t.string :attribute
      t.string :target
      t.string :modifier
      t.string :element
      t.string :type

      t.timestamps
    end
  end
end
