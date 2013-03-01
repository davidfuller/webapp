require 'test_helper'

class DynamicSpecialsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:dynamic_specials)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create dynamic_special" do
    assert_difference('DynamicSpecial.count') do
      post :create, :dynamic_special => { }
    end

    assert_redirected_to dynamic_special_path(assigns(:dynamic_special))
  end

  test "should show dynamic_special" do
    get :show, :id => dynamic_specials(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => dynamic_specials(:one).to_param
    assert_response :success
  end

  test "should update dynamic_special" do
    put :update, :id => dynamic_specials(:one).to_param, :dynamic_special => { }
    assert_redirected_to dynamic_special_path(assigns(:dynamic_special))
  end

  test "should destroy dynamic_special" do
    assert_difference('DynamicSpecial.count', -1) do
      delete :destroy, :id => dynamic_specials(:one).to_param
    end

    assert_redirected_to dynamic_specials_path
  end
end
