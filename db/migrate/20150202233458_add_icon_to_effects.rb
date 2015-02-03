class AddIconToEffects < ActiveRecord::Migration
  def change
    add_column :effects, :icon, :string, default: "https://s3-us-west-2.amazonaws.com/monbattle/images/frank.jpg"
  end
end
