class CreateUnlocks < ActiveRecord::Migration
  def change
    create_table :unlocks do |t|
      t.references :monster, index: true
      t.references :user, index: true

      t.timestamps
    end
  end
end
