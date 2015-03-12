class Relationship < ActiveRecord::Base

  require 'neo4j-core'

  belongs_to :entity_to, :class_name => "EntityInstance", :foreign_key => "entity_instance_to"
  belongs_to :entity_from, :class_name => "EntityInstance", :foreign_key => "entity_instance_from"
  has_many :relationship_bits, dependent: :destroy

  
  belongs_to :relationship_type, :class_name => "RelationshipType", :foreign_key => "relationship_type_id"

  paginates_per 5

  belongs_to :user

  after_update :update_neo4j_relationship
  after_create :create_neo4j_relationship
  before_destroy :destroy_neo4j_relationship

  private
    def destroy_neo4j_relationship
      unless rel_node_id.nil?
        Neo4j::Relationship.load(rel_node_id).del
      end
    end

    def create_neo4j_relationship
      node_from = Neo4j::Node.load(entity_from.node_id) #Neo4j::Node.create
      node_to = Neo4j::Node.load(entity_to.node_id)
      rel_type = relationship_type
      node_rel = node_from.create_rel(rel_type.name, node_to)
      update_column(:rel_node_id, node_rel.neo_id)
    end

    def update_neo4j_relationship
      destroy_neo4j_relationship
      create_neo4j_relationship
    end
end
