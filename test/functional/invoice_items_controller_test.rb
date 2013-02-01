require 'test_helper'

class InvoiceItemsControllerTest < ActionController::TestCase
  setup do
    @invoice_item = invoice_items(:one)
    @invoice = @invoice_item.invoice
  end

  test "should get index" do
    get :index, invoice_id: @invoice
    assert_response :success
    assert_not_nil assigns(:invoice_items)
  end

  test "should get new" do
    get :new, invoice_id: @invoice
    assert_response :success
  end

  test "should create invoice_item" do
    assert_difference('InvoiceItem.count') do
      post :create, {
        :invoice_id => invoices(:one).id, 
        :invoice_item => {
          :description => 'some description', 
          :discount => 0, :quantity=>2, :unitary_cost=> 2}}
    end

    assert_redirected_to invoice_invoice_item_path(assigns(:invoice), assigns(:invoice_item))
  end

  test "should show invoice_item" do
    get :show, {:invoice_id=> @invoice, :id=> @invoice_item}
    assert_response :success
  end

  test "should get edit" do
    get :edit, {:invoice_id=> @invoice, :id=> @invoice_item}
    assert_response :success
  end

  test "should update invoice_item" do
    put :update, invoice_id: @invoice, id: @invoice_item, invoice_item: {  }
    assert_redirected_to invoice_invoice_item_path(assigns(:invoice), assigns(:invoice_item))
  end

  test "should destroy invoice_item" do
    assert_difference('InvoiceItem.count', -1) do
      delete :destroy, {:invoice_id=> @invoice, :id => @invoice_item}
    end

    assert_redirected_to invoice_invoice_items_path(@invoice)
  end
end
