class AddReferencesToSkinRestrictions < ActiveRecord::Migration
  def change
    add_reference :skin_restrictions, :job, index: true
  end
end
