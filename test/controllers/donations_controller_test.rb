require 'test_helper'

class DonationsControllerTest < ActionController::TestCase
  setup do
    @donation = donations(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:donations)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create donation" do
    assert_difference('Donation.count') do
      post :create, donation: { amount: @donation.amount, city: @donation.city, date_of_birth: @donation.date_of_birth, donor_type: @donation.donor_type, email: @donation.email, ic: @donation.ic, name: @donation.name, organization_id: @donation.organization_id, person_id: @donation.person_id, street: @donation.street, zip: @donation.zip }
    end

    assert_redirected_to donation_path(assigns(:donation))
  end

  test "should show donation" do
    get :show, id: @donation
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @donation
    assert_response :success
  end

  test "should update donation" do
    patch :update, id: @donation, donation: { amount: @donation.amount, city: @donation.city, date_of_birth: @donation.date_of_birth, donor_type: @donation.donor_type, email: @donation.email, ic: @donation.ic, name: @donation.name, organization_id: @donation.organization_id, person_id: @donation.person_id, street: @donation.street, zip: @donation.zip }
    assert_redirected_to donation_path(assigns(:donation))
  end

  test "should destroy donation" do
    assert_difference('Donation.count', -1) do
      delete :destroy, id: @donation
    end

    assert_redirected_to donations_path
  end
end
