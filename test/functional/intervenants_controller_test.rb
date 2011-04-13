require 'test_helper'

class IntervenantsControllerTest < ActionController::TestCase
  setup do
    @intervenant = intervenants(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:intervenants)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create intervenant" do
    assert_difference('Intervenant.count') do
      post :create, :intervenant => @intervenant.attributes
    end

    assert_redirected_to intervenant_path(assigns(:intervenant))
  end

  test "should show intervenant" do
    get :show, :id => @intervenant.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @intervenant.to_param
    assert_response :success
  end

  test "should update intervenant" do
    put :update, :id => @intervenant.to_param, :intervenant => @intervenant.attributes
    assert_redirected_to intervenant_path(assigns(:intervenant))
  end

  test "should destroy intervenant" do
    assert_difference('Intervenant.count', -1) do
      delete :destroy, :id => @intervenant.to_param
    end

    assert_redirected_to intervenants_path
  end
end
