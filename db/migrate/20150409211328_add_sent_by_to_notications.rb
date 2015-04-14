class AddSentByToNotications < ActiveRecord::Migration
  def change
    add_column :notications, :sent_by, :string
    add_column :notications, :noticapable_id, :integer
    add_column :notications, :noticapable_type, :string
    add_index :notications, :noticapable_id
  end
end
