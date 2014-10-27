class AbilityRestriction < ActiveRecord::Base
  belongs_to :job
  belongs_to :ability

  def self.find_abilities_avail_for_job_id(job_id)
    where(job_id: job_id).pluck(:ability_id)
  end

end
