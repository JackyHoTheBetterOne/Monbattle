class AddValidationStatesToBattles < ActiveRecord::Migration
  def change
    add_column :battles, :after_action_state, :text
    add_column :battles, :before_action_state, :text
  end
end
