require 'test_helper'

class InvoicesControllerTest < ActionController::TestCase
  setup do
    @invoice = invoices(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:invoices)
  end

  test "should search" do
    get :index, search_term: 'X-1234-C2'
    assert_response :success
    assert_not_nil assigns(:invoices)
    assert_equal assigns(:invoices).count, 1
    assert_equal assigns(:invoices)[0].customer_name, 'Customer two'
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create invoice" do
    assert_difference('Invoice.count') do
      post :create, invoice: { customer_email: @invoice.customer_email, customer_identification: @invoice.customer_identification, customer_name: @invoice.customer_name , number: 33}
    end

    assert_redirected_to invoice_path(assigns(:invoice))
  end

  test "should show invoice" do
    get :show, id: @invoice
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @invoice
    assert_response :success
  end

  test "should update invoice" do
    put :update, id: @invoice, invoice: { customer_email: @invoice.customer_email, customer_identification: @invoice.customer_identification, customer_name: @invoice.customer_name , number: 332}
    assert_redirected_to invoice_path(assigns(:invoice))
  end

  test "should update invoice with items and payments" do
    first_item = @invoice.invoice_items[0]
    second_item = @invoice.invoice_items[1]
    put :update, id: @invoice, invoice: { customer_email: 'new customer email', 
      customer_identification: @invoice.customer_identification, 
      customer_name: @invoice.customer_name, number: 111, 
      invoice_items_attributes: {
        xxxy: {description: 'mod desc', discount: 0, 
          quantity: 3, unitary_cost: '11.2' , id: first_item.id}, 
        xxxy2: {description: second_item.description, 
          unitary_cost: '11.2' , id: second_item.id, _destroy: true},
        xxxy3: {description: 'new item desc', discount: 0,
          quantity: 22, unitary_cost: '33'}
      }, 
      payments_attributes: [{notes: 'test note', amount: 12.3, date: '2012-01-01'}]}
    assert_redirected_to invoice_path(assigns(:invoice))
    inv = Invoice.find(assigns(:invoice).id)
    # invoice modified
    assert_equal inv.number, 111
    # firt item modified
    assert_equal inv.invoice_items[0].unitary_cost, 11.2
    # second item deleted, and a new one created instead
    assert_equal inv.invoice_items[1].description, 'new item desc'
    # one payment created
    assert_equal inv.payments[ inv.payments.count - 1 ].notes, 'test note'
    assert_equal inv.payments[ inv.payments.count - 1 ].amount, 12.3
    

  end

  test "should destroy invoice" do
    assert_difference('Invoice.count', -1) do
      delete :destroy, id: @invoice
    end

    assert_redirected_to invoices_path
  end
end
