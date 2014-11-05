class RenameElementTemplatesToElements < ActiveRecord::Migration
  def change
    create_table "elements", force: true do |t|
      t.string   "name"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  end
end
