class InvoiceItemsController < ApplicationController
  # GET /invoice_items
  # GET /invoice_items.json
  def index
    @invoice_items = InvoiceItem.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @invoice_items }
    end
  end

  # GET /invoice_items/1
  # GET /invoice_items/1.json
  def show
    @invoice_item = InvoiceItem.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @invoice_item }
    end
  end

  # GET /invoice_items/new
  # GET /invoice_items/new.json
  def new
    @invoice_item = InvoiceItem.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @invoice_item }
    end
  end

  # GET /invoice_items/1/edit
  def edit
    @invoice_item = InvoiceItem.find(params[:id])
  end

  # POST /invoice_items
  # POST /invoice_items.json
  def create
    @invoice_item = InvoiceItem.new(params[:invoice_item])

    respond_to do |format|
      if @invoice_item.save
        format.html { redirect_to @invoice_item, notice: 'Invoice item was successfully created.' }
        format.json { render json: @invoice_item, status: :created, location: @invoice_item }
      else
        format.html { render action: "new" }
        format.json { render json: @invoice_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /invoice_items/1
  # PUT /invoice_items/1.json
  def update
    @invoice_item = InvoiceItem.find(params[:id])

    respond_to do |format|
      if @invoice_item.update_attributes(params[:invoice_item])
        format.html { redirect_to @invoice_item, notice: 'Invoice item was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @invoice_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /invoice_items/1
  # DELETE /invoice_items/1.json
  def destroy
    @invoice_item = InvoiceItem.find(params[:id])
    @invoice_item.destroy

    respond_to do |format|
      format.html { redirect_to invoice_items_url }
      format.json { head :no_content }
    end
  end
end
