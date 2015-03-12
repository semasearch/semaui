require 'neo4j-core'


class RelationshipsController < ApplicationController
  authorize_resource
  before_action :set_relationship, only: [:show, :edit, :update, :destroy]
  before_action :init_neo4j_session, only: [:create, :update]
  include Graphstorage


  def new 
    @relationship = Relationship.new
  
  end
  
  def create
    @relationship = Relationship.new(relationship_params)
    @relationship.user = current_user
    @relationship.relationship_type = RelationshipType.find_or_create_by(name: params[:relationship][:relationship_type])
        
    if @relationship.save

      redirect_to @relationship
    else 
      render 'new'
    end 
  end

  def destroy

    @relationship.destroy
    
    redirect_to relationships_path
  end
  
  def show
  end
  
  def index
    @relationships = Relationship.all.page(params[:page])
  end

  def preview
    @relationship = Relationship.find(params[:relationship_id])
  end
  
  def update
    
    #@entity_instance_to = EntityInstance.find(params["entity_instance_to"])
    #@entity_instance_from = EntityInstance.find(params["entity_instance_from"])
    #@relationship.entity_instance_to = @entity_instance_to
    #@relationship.entity_instance_from = @entity_instance_from
    
    @relationship.relationship_type = RelationshipType.find_or_create_by(name: params[:relationship][:relationship_type])
    if @relationship.update(relationship_params)
      redirect_to @relationship
    else
      render 'edit'
    end
  end

  def edit
    @type = @relationship.relationship_type.name
  end

  def autocomplete_type
    @results = RelationshipType.search(params[:query], fields: [:name], limit: 10).results 
    @results = RelationshipType.where("name like ?", "%#{params[:query]}%").limit(10) if @results.empty?
    render json: @results
  end
  
  private

    def set_relationship
      @relationship = Relationship.find(params[:id])
    end

    def relationship_params
      params.require(:relationship).permit(:name, :description, :entity_instance_from, :entity_instance_to, :relationship_type_id)
    end
end
