class ChangeDetaultAgainOnAbilityImage < ActiveRecord::Migration
  def change
    remove_column :abilities, :image
    add_column :abilities, :image, :text, default: "https://s3-us-west-2.amazonaws.com/monbattle/images/ability_animation/explosion-final.svg"
  end
end
