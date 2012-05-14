require 'test_helper'

class ConstantsControllerTest < ActionController::TestCase
  setup do
    @constant = constants(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:constants)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create constant" do
    assert_difference('Constant.count') do
      post :create, :constant => { :name => @constant.name, :value => @constant.value }
    end

    assert_redirected_to constant_path(assigns(:constant))
  end

  test "should show constant" do
    get :show, :id => @constant
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @constant
    assert_response :success
  end

  test "should update constant" do
    put :update, :id => @constant, :constant => { :name => @constant.name, :value => @constant.value }
    assert_redirected_to constant_path(assigns(:constant))
  end

  test "should destroy constant" do
    assert_difference('Constant.count', -1) do
      delete :destroy, :id => @constant
    end

    assert_redirected_to constants_path
  end
end
