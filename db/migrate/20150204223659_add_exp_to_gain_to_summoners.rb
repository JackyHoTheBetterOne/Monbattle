class AddExpToGainToSummoners < ActiveRecord::Migration
  def change
    add_column :summoners, :exp_to_gain, :integer
  end
end
