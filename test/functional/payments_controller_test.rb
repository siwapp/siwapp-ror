require 'test_helper'

class PaymentsControllerTest < ActionController::TestCase
  setup do
    @payment = payments(:one)
    @invoice = @payment.invoice
  end

  test "should get index" do
    get :index, invoice_id: @invoice
    assert_response :success
    assert_not_nil assigns(:payments)
  end

  test "should get new" do
    get :new, invoice_id: @invoice
    assert_response :success
  end

  test "should create invoice_item" do
    assert_difference('Payment.count') do
      post :create, {
        invoice_id: invoices(:one).id,
        payment: {
          notes: 'some notes',
          amount: 123.45,
          date: '2012-05-05'
        }
      }
      end

    assert_redirected_to invoice_payments_path(assigns(:invoice), assigns(:payments))
  end


  test "should get edit" do
    get :edit, invoice_id: @invoice, id: @payment
    assert_response :success
  end


  test "should update payment" do
    put :update, invoice_id: @invoice, id: @payment, payment: {}
    assert_redirected_to invoice_payments_path assigns(:invoice)
  end

  test "should destroy payment" do
    assert_difference('Payment.count', -1) do
      delete :destroy, invoice_id: @invoice, id: @payment
    end

    assert_redirected_to invoice_payments_path @invoice
  end
end
