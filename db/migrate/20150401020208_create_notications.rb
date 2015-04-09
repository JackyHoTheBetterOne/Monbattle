class CreateNotications < ActiveRecord::Migration
  def change
    create_table :notications do |t|
      t.string :title
      t.text :message
      t.text :type
      t.text :present_array, array: true, default: []
      t.datetime :expiry_time

      t.timestamps
    end
  end
end
