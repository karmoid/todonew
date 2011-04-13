require 'test_helper'

class OpegroupsControllerTest < ActionController::TestCase
  setup do
    @opegroup = opegroups(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:opegroups)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create opegroup" do
    assert_difference('Opegroup.count') do
      post :create, :opegroup => @opegroup.attributes
    end

    assert_redirected_to opegroup_path(assigns(:opegroup))
  end

  test "should show opegroup" do
    get :show, :id => @opegroup.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @opegroup.to_param
    assert_response :success
  end

  test "should update opegroup" do
    put :update, :id => @opegroup.to_param, :opegroup => @opegroup.attributes
    assert_redirected_to opegroup_path(assigns(:opegroup))
  end

  test "should destroy opegroup" do
    assert_difference('Opegroup.count', -1) do
      delete :destroy, :id => @opegroup.to_param
    end

    assert_redirected_to opegroups_path
  end
end
