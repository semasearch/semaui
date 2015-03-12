class RelationshipBitsController < ApplicationController
  authorize_resource
  before_action :set_relationship

  def index
    @relationship_bits = @relationship.relationship_bits.page(params[:page]).per(25)
  end

  def create
    @relationship_bit = @relationship.relationship_bits.create(relationship_bit_params)
    redirect_to relationship_relationship_bits_path(@relationship)
  end

  def destroy
    @relationship_bit = @relationship.relationship_bits.find(params[:id])
    @relationship_bit.destroy
    redirect_to relationship_path(@relationship)
  end
 
  private

    def set_relationship
      @relationship = Relationship.find(params[:relationship_id])
    end

    def relationship_bit_params
      params.require(:relationship_bit).permit(:url, :comment, :fulltext)
    end
end
