class CreateAvatars < ActiveRecord::Migration
  def change
    create_table :avatars do |t|
      t.string :name
      t.text :image_link

      t.timestamps
    end
  end
end
