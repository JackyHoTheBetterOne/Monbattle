class AddClassTemplateToAbilities < ActiveRecord::Migration
  def change
    add_reference :abilities, :class_template, index: true
  end
end
