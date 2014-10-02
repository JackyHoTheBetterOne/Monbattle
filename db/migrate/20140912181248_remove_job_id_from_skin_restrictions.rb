class RemoveJobIdFromSkinRestrictions < ActiveRecord::Migration
  def change
    remove_reference :skin_restrictions, :job_id, index: true
  end
end
