class AddNodeIdColumntoEntityInstance < ActiveRecord::Migration
  def change
    add_column :entity_instances, :node_id, :string
  end
end
