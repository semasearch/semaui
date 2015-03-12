class CreateRelationships < ActiveRecord::Migration
  def change
    create_table :relationships do |t|
      t.string :name
      t.integer :entity_instance_to, index: true
      t.integer :entity_instance_from, index: true

      t.timestamps
    end
  end
end
