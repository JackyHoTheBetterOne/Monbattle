class RemoveClassTemplateIdFromAbilities < ActiveRecord::Migration
  def change
    remove_reference :abilities, :class_template, index: true
  end
end
