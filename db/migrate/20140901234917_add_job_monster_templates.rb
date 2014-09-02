class AddJobMonsterTemplates < ActiveRecord::Migration
  def change
    add_column :monster_templates, :job, :string
  end
end
