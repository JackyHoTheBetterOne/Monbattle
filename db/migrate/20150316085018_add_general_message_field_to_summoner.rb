class AddGeneralMessageFieldToSummoner < ActiveRecord::Migration
  def change
    add_column :summoners, :general_messages, :text, array: true, default: []
  end
end
