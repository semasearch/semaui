class SuggestRelationship < ActiveRecord::Base
  validates_presence_of :entity_instance_to, :entity_instance_from, :relationship_type, :url
end
