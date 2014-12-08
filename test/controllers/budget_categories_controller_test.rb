require 'test_helper'

class BudgetCategoriesControllerTest < ActionController::TestCase
  setup do
    @budget_category = budget_categories(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:budget_categories)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create budget_category" do
    assert_difference('BudgetCategory.count') do
      post :create, budget_category: { name: @budget_category.name, organization_id: @budget_category.organization_id, year: @budget_category.year }
    end

    assert_redirected_to budget_category_path(assigns(:budget_category))
  end

  test "should show budget_category" do
    get :show, id: @budget_category
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @budget_category
    assert_response :success
  end

  test "should update budget_category" do
    patch :update, id: @budget_category, budget_category: { name: @budget_category.name, organization_id: @budget_category.organization_id, year: @budget_category.year }
    assert_redirected_to budget_category_path(assigns(:budget_category))
  end

  test "should destroy budget_category" do
    assert_difference('BudgetCategory.count', -1) do
      delete :destroy, id: @budget_category
    end

    assert_redirected_to budget_categories_path
  end
end
