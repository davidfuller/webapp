require 'test_helper'

class ProducersControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:producers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create producer" do
    assert_difference('Producer.count') do
      post :create, :producer => { }
    end

    assert_redirected_to producer_path(assigns(:producer))
  end

  test "should show producer" do
    get :show, :id => producers(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => producers(:one).to_param
    assert_response :success
  end

  test "should update producer" do
    put :update, :id => producers(:one).to_param, :producer => { }
    assert_redirected_to producer_path(assigns(:producer))
  end

  test "should destroy producer" do
    assert_difference('Producer.count', -1) do
      delete :destroy, :id => producers(:one).to_param
    end

    assert_redirected_to producers_path
  end
end
