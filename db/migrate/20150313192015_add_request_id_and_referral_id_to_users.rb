class AddRequestIdAndReferralIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :invite_ids, :text, array: true, default: []
    add_column :users, :request_ids, :text, array: true, default: []
  end
end
