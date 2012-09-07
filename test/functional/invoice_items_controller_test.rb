require 'test_helper'

class InvoiceItemsControllerTest < ActionController::TestCase
  setup do
    @invoice_item = invoice_items(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:invoice_items)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create invoice_item" do
    assert_difference('InvoiceItem.count') do
      post :create, invoice_item: {  }
    end

    assert_redirected_to invoice_item_path(assigns(:invoice_item))
  end

  test "should show invoice_item" do
    get :show, id: @invoice_item
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @invoice_item
    assert_response :success
  end

  test "should update invoice_item" do
    put :update, id: @invoice_item, invoice_item: {  }
    assert_redirected_to invoice_item_path(assigns(:invoice_item))
  end

  test "should destroy invoice_item" do
    assert_difference('InvoiceItem.count', -1) do
      delete :destroy, id: @invoice_item
    end

    assert_redirected_to invoice_items_path
  end
end
