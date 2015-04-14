class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.string :title
      t.text :content
      t.string :sent_by
      t.string :type
      t.hstore :information_object
      t.integer :notificapable_id
      t.string :notificapable_type
      t.timestamps
    end
    add_index :notifications, :notificapable_id 
  end
end
