# == Schema Information
#
# Table name: entity_instances
#
#  id             :integer          not null, primary key
#  name           :string(255)
#  description    :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#  node_id        :string(255)
#  entity_type_id :integer
#  user_id        :integer
#

class EntityInstance < ActiveRecord::Base

  include Rails.application.routes.url_helpers
  require 'neo4j-core'
  include SearchHelper

  searchkick text_start: ['name']

  validates :name, presence: true,
                    length: { minimum: 1 }
                    
  paginates_per 5
  
  has_many :relationships_from, :class_name => "Relationship", :foreign_key => "entity_instance_from"
  has_many :relationships_to, :class_name => "Relationship", :foreign_key => "entity_instance_to"
  
  belongs_to :entity_type
  belongs_to :user

  after_update :update_node
  after_create :create_node
  before_destroy :destroy_relationship, :destroy_graph_entities

  # def encode_with(coder)
  #   coder['name'] = @name
  #   coder['description'] = @description
  #   coder['created_at'] = @created_at
  #   coder['updated_at'] = @updated_at
  #   coder['entity_type_id'] = @entity_type_id
  #   coder['user_id'] = @user_id
  # end

  # def init_with(coder)
  #   @name = coder['name']
  #   @description = coder['description']
  #   @created_at = coder['created_at']
  #   @updated_at = coder['updated_at']
  #   @entity_type_id = coder['entity_type_id']
  #   @user_id = coder['user_id']
  # end

  def self.search_for_graph(search)
  	search(search).results.first || where("name like ?", "%#{search}%").first
  end

  def parse_info
    info = Hash.new
    info[:link] = entity_instance_path(id) + '/preview'
    info[:name] = ERB::Util.html_escape(name)
    info[:description] = ''
    if description
      info[:description] = description unless description.empty?
    end
    info
  end

  def delete_label
    node = Neo4j::Node.load(node_id)
    node.remove_label(entity_type.name)
  end

  private
    def update_node
      Neo4j::Session.create_session(:server_db, "http://localhost:7474")
      node = Neo4j::Node.load(node_id)
      node.props = {entity_id: id, name: name, description: description}
      node.set_label(entity_type.name)
    end

    def create_node
      Neo4j::Session.create_session(:server_db, "http://localhost:7474")
      node = Neo4j::Node.create({entity_id: id, name: name, description: description })
      node.set_label(entity_type.name)
      update_column(:node_id, node.neo_id)
    end

    def destroy_relationship
      relationships_to.destroy_all
      relationships_from.destroy_all
    end

    def destroy_graph_entities
      unless node_id.nil?
        Neo4j::Node.load(node_id).del
      end 
    end

end
