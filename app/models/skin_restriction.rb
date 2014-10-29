class SkinRestriction < ActiveRecord::Base
  belongs_to :job
  belongs_to :monster_skin

  def self.find_monster_skins_avail_for_job_id(job_id)
    where(job_id: job_id).pluck(:monster_skin_id)
  end

end
