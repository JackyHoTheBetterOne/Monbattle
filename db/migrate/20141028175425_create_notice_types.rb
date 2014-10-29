class CreateNoticeTypes < ActiveRecord::Migration
  def change
    create_table :notice_types do |t|
      t.string :name
      t.timestamps
    end
  end
end
