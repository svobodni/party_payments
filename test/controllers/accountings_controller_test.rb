require 'test_helper'

class AccountingsControllerTest < ActionController::TestCase
  setup do
    @accounting = accountings(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:accountings)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create accounting" do
    assert_difference('Accounting.count') do
      post :create, accounting: { accountable_id: @accounting.accountable_id, accountable_type: @accounting.accountable_type, amount: @accounting.amount, budget_category_id: @accounting.budget_category_id, payment_id: @accounting.payment_id, payment_type: @accounting.payment_type }
    end

    assert_redirected_to accounting_path(assigns(:accounting))
  end

  test "should show accounting" do
    get :show, id: @accounting
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @accounting
    assert_response :success
  end

  test "should update accounting" do
    patch :update, id: @accounting, accounting: { accountable_id: @accounting.accountable_id, accountable_type: @accounting.accountable_type, amount: @accounting.amount, budget_category_id: @accounting.budget_category_id, payment_id: @accounting.payment_id, payment_type: @accounting.payment_type }
    assert_redirected_to accounting_path(assigns(:accounting))
  end

  test "should destroy accounting" do
    assert_difference('Accounting.count', -1) do
      delete :destroy, id: @accounting
    end

    assert_redirected_to accountings_path
  end
end
