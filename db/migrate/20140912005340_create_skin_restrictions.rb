class CreateSkinRestrictions < ActiveRecord::Migration
  def change
    create_table :skin_restrictions do |t|
      t.references :job_id, index: true
      t.references :monster_skin, index: true

      t.timestamps
    end
  end
end
