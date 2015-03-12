class ChangeColumnTypeFromSuggestRel < ActiveRecord::Migration
  def change
    rename_column :suggest_relationships, :relationship_type_id, :relationship_type
    change_column :suggest_relationships, :relationship_type, :string
  end
end
