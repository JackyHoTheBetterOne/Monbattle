class CreateFights < ActiveRecord::Migration
  def change
    create_table :fights do |t|
      t.references :user, index: true
      t.references :battle, index: true

      t.timestamps
    end
  end
end
