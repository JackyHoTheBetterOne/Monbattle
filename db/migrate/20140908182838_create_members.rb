class CreateMembers < ActiveRecord::Migration
  def change
    create_table :members do |t|
      t.references :monster, index: true
      t.references :party, index: true

      t.timestamps
    end
  end
end
