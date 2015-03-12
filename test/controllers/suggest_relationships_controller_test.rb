require 'test_helper'

class SuggestRelationshipsControllerTest < ActionController::TestCase
  setup do
    @suggest_relationship = suggest_relationships(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:suggest_relationships)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create suggest_relationship" do
    assert_difference('SuggestRelationship.count') do
      post :create, suggest_relationship: { entity_instance_from: @suggest_relationship.entity_instance_from, entity_instance_to: @suggest_relationship.entity_instance_to, relationship_type_id: @suggest_relationship.relationship_type_id, url: @suggest_relationship.url }
    end

    assert_redirected_to suggest_relationship_path(assigns(:suggest_relationship))
  end

  test "should show suggest_relationship" do
    get :show, id: @suggest_relationship
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @suggest_relationship
    assert_response :success
  end

  test "should update suggest_relationship" do
    patch :update, id: @suggest_relationship, suggest_relationship: { entity_instance_from: @suggest_relationship.entity_instance_from, entity_instance_to: @suggest_relationship.entity_instance_to, relationship_type_id: @suggest_relationship.relationship_type_id, url: @suggest_relationship.url }
    assert_redirected_to suggest_relationship_path(assigns(:suggest_relationship))
  end

  test "should destroy suggest_relationship" do
    assert_difference('SuggestRelationship.count', -1) do
      delete :destroy, id: @suggest_relationship
    end

    assert_redirected_to suggest_relationships_path
  end
end
