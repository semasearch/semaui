class SuggestRelationshipsController < ApplicationController
  before_action :set_suggest_relationship, only: [:show, :edit, :update, :destroy]
  authorize_resource

  # GET /suggest_relationships
  # GET /suggest_relationships.json
  def index
    @suggest_relationships = SuggestRelationship.all
  end

  # GET /suggest_relationships/1
  # GET /suggest_relationships/1.json
  def show
  end

  # GET /suggest_relationships/new
  def new
    @suggest_relationship = SuggestRelationship.new
  end

  # GET /suggest_relationships/1/edit
  def edit
  end

  # POST /suggest_relationships
  # POST /suggest_relationships.json
  def create
    @suggest_relationship = SuggestRelationship.new(suggest_relationship_params)

    respond_to do |format|
      if @suggest_relationship.save
        format.html { redirect_to root_path, notice: 'Suggest relationship was successfully created.' }
        format.json { render :show, status: :created, location: @suggest_relationship }
      else
        format.html { redirect_to root_path }
        format.json { render json: @suggest_relationship.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /suggest_relationships/1
  # PATCH/PUT /suggest_relationships/1.json
  def update
    respond_to do |format|
      if @suggest_relationship.update(suggest_relationship_params)
        format.html { redirect_to @suggest_relationship, notice: 'Suggest relationship was successfully updated.' }
        format.json { render :show, status: :ok, location: @suggest_relationship }
      else
        format.html { render :edit }
        format.json { render json: @suggest_relationship.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /suggest_relationships/1
  # DELETE /suggest_relationships/1.json
  def destroy
    @suggest_relationship.destroy
    respond_to do |format|
      format.html { redirect_to suggest_relationships_url, notice: 'Suggest relationship was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_suggest_relationship
      @suggest_relationship = SuggestRelationship.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def suggest_relationship_params
      params.require(:suggest_relationship).permit(:entity_instance_to, :entity_instance_from, :relationship_type, :url)
    end
end
