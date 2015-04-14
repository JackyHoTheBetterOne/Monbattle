class RemoveNotications < ActiveRecord::Migration
  def change
    drop_table :notications
  end
end
