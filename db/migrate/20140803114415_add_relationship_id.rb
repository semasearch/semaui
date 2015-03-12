class AddRelationshipId < ActiveRecord::Migration
  def change
    add_column :relationships, :rel_node_id, :string
  end
end
