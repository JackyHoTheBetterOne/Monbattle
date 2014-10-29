class AddTypeReferenceToNotice < ActiveRecord::Migration
  def change
    add_column :notices, :notice_type_id, :integer
  end
end
