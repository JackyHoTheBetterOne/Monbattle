class CreateParties < ActiveRecord::Migration
  def change
    create_table :parties do |t|
      t.references :user, index: true
      t.string :name

      t.timestamps
    end
  end
end
