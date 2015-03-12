class CreateEntityTypes < ActiveRecord::Migration
  def change
    create_table :entity_types do |t|
      t.string :name

      t.timestamps
    end
    
    add_column :entity_instances, :entity_type_id, :integer
     
  end
end
