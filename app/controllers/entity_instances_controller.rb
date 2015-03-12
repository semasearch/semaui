require 'neo4j-core'

class EntityInstancesController < ApplicationController
  authorize_resource
  before_action :set_entity_instance, only: [:show, :edit, :update, :destroy, :load_info]
  before_action :init_neo4j_session, only: [:create, :update]
  before_action :delete_old_label, only: :update

  def new 
    @entity_instance = EntityInstance.new
  
  end
  
  def create
    @entity_instance = EntityInstance.new(entity_instance_params)
    @entity_instance.user = current_user
    @entity_instance.entity_type = EntityType.find_or_create_by(name: params[:entity_instance][:entity_type])
    
    if @entity_instance.save
      redirect_to @entity_instance
    else
      render 'new'
    end
    
  end
  
  def nodes
    render 'new'
  end
  
  def destroy
    @entity_instance.destroy
    
    redirect_to entity_instances_path
  end
  
  def update
    @entity_instance.entity_type = EntityType.find_or_create_by(name: params[:entity_instance][:entity_type])
    if @entity_instance.update(entity_instance_params)
      redirect_to @entity_instance
    else
      render 'edit'
    end
  end

  def edit
    @type = @entity_instance.entity_type.name
  end
  
  def show
    @entity_type = @entity_instance.entity_type
  end

  def preview
    @entity_instance = EntityInstance.find(params[:entity_instance_id])
    @entity_type = @entity_instance.entity_type
  end
  
  def index
    @entity_instances = EntityInstance.all.page(params[:page])
  end

  def autocomplete
    @results = EntityInstance.search(params[:query], fields: [:name], limit: 10).results
    @results = EntityInstance.where("name like ?", "%#{params[:query]}%").limit(10) if @results.empty?
    render json: @results
  end

  def autocomplete_type
    @results = EntityType.search(params[:query], fields: [:name], limit: 10).results 
    @results = EntityType.where("name like ?", "%#{params[:query]}%").limit(10) if @results.empty?
    render json: @results
  end
  
  private

    def set_entity_instance
      @entity_instance = EntityInstance.find(params[:id])
    end

    def entity_instance_params
      params.require(:entity_instance).permit(:name, :description, :entity_type_id)
    end

    def delete_old_label
      @entity_instance.delete_label
    end

end
