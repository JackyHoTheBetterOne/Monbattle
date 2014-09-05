class CreateEvolvedStates < ActiveRecord::Migration
  def change
    create_table :evolved_states do |t|
      t.string :name
      t.references :job, index: true
      t.references :element, index: true
      t.references :monster_skin_id, index: true
      t.integer :evolve_lvl
      t.integer :created_from_id

      t.timestamps
    end
  end
end
