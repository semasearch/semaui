class AddUserToEntityInstanceAndToRelationship < ActiveRecord::Migration
  def change
  	add_reference :entity_instances, :user, index: true
   	add_reference :relationships, :user, index: true
  end
end
