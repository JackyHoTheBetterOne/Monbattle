class CreateThoughts < ActiveRecord::Migration
  def change
    create_table :thoughts do |t|
      t.references :personality, index: true
      t.text :comment

      t.timestamps
    end
  end
end
