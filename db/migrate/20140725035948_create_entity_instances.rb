class CreateEntityInstances < ActiveRecord::Migration
  def change
    create_table :entity_instances do |t|
      t.string :name
      t.string :description
      t.datetime :created_at

      t.timestamps
    end
  end
end
