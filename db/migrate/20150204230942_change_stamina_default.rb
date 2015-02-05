class ChangeStaminaDefault < ActiveRecord::Migration
  def change
    change_column :summoners, :stamina, :integer, default: 15
  end
end
