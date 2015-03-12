class CreateRelationshipTypes < ActiveRecord::Migration
  def change
    create_table :relationship_types do |t|
      t.string :name

      t.timestamps
    end
    
    add_column :relationships, :relationship_type_id, :integer
  end
end
