require 'test_helper'

class ReviewPermissionsControllerTest < ActionController::TestCase
  setup do
    @review_permission = review_permissions(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:review_permissions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create review_permission" do
    assert_difference('ReviewPermission.count') do
      post :create, :review_permission => @review_permission.attributes
    end

    assert_redirected_to review_permission_path(assigns(:review_permission))
  end

  test "should show review_permission" do
    get :show, :id => @review_permission.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @review_permission.to_param
    assert_response :success
  end

  test "should update review_permission" do
    put :update, :id => @review_permission.to_param, :review_permission => @review_permission.attributes
    assert_redirected_to review_permission_path(assigns(:review_permission))
  end

  test "should destroy review_permission" do
    assert_difference('ReviewPermission.count', -1) do
      delete :destroy, :id => @review_permission.to_param
    end

    assert_redirected_to review_permissions_path
  end
end
