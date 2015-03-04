class AddTimeLimtiedAbilityToAreas < ActiveRecord::Migration
  def change
    add_column :areas, :banner, :string
    add_column :areas, :start_date, :datetime, default: nil
    add_column :areas, :end_date, :datetime, default: nil
  end
end
