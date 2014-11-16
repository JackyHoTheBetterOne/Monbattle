class CreateArcs < ActiveRecord::Migration
  def change
    create_table :arcs do |t|
      t.string :name
      t.timestamps
    end
  end
end
