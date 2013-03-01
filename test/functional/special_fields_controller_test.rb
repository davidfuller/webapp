require 'test_helper'

class SpecialFieldsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:special_fields)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create special_field" do
    assert_difference('SpecialField.count') do
      post :create, :special_field => { }
    end

    assert_redirected_to special_field_path(assigns(:special_field))
  end

  test "should show special_field" do
    get :show, :id => special_fields(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => special_fields(:one).to_param
    assert_response :success
  end

  test "should update special_field" do
    put :update, :id => special_fields(:one).to_param, :special_field => { }
    assert_redirected_to special_field_path(assigns(:special_field))
  end

  test "should destroy special_field" do
    assert_difference('SpecialField.count', -1) do
      delete :destroy, :id => special_fields(:one).to_param
    end

    assert_redirected_to special_fields_path
  end
end
