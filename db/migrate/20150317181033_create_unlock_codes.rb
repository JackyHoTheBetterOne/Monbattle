class CreateUnlockCodes < ActiveRecord::Migration
  def change
    create_table :unlock_codes do |t|
      t.text   :code
      t.string :category
      t.integer :item_id
      t.datetime :expiry_date

      t.timestamps
    end
  end
end
