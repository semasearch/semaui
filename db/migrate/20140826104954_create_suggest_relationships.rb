class CreateSuggestRelationships < ActiveRecord::Migration
  def change
    create_table :suggest_relationships do |t|
      t.string :entity_instance_to
      t.string :entity_instance_from
      t.integer :relationship_type_id
      t.string :url

      t.timestamps
    end
  end
end
