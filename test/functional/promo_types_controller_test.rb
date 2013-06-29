require 'test_helper'

class PromoTypesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:promo_types)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create promo_type" do
    assert_difference('PromoType.count') do
      post :create, :promo_type => { }
    end

    assert_redirected_to promo_type_path(assigns(:promo_type))
  end

  test "should show promo_type" do
    get :show, :id => promo_types(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => promo_types(:one).to_param
    assert_response :success
  end

  test "should update promo_type" do
    put :update, :id => promo_types(:one).to_param, :promo_type => { }
    assert_redirected_to promo_type_path(assigns(:promo_type))
  end

  test "should destroy promo_type" do
    assert_difference('PromoType.count', -1) do
      delete :destroy, :id => promo_types(:one).to_param
    end

    assert_redirected_to promo_types_path
  end
end
