class TemplatesController < ApplicationController
  before_action :set_type
  before_action :set_template, only: [:show, :edit, :update, :destroy]

  # GET /templates
  # GET /templates.json
  def index
    @templates = Template.all
  end

  # GET /templates/1
  # GET /templates/1.json
  def show
  end

  # GET /templates/new
  def new
    @template = Template.new
  end

  # GET /templates/1/edit
  def edit
  end

  # POST /templates
  # POST /templates.json
  def create
    @template = Template.new(template_params)

    respond_to do |format|
      if @template.save
        format.html { redirect_to templates_url, notice: 'Template was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  # POST /templates
  # updates default template
  def set_default
    # Gets the selected templates ids
    email_selected = params["email_default_template"]
    print_selected = params["print_default_template"]
    
    # Gets the current defaults
    current_email_default = Template.find_by(email_default: true)
    current_print_default = Template.find_by(print_default: true)
    
    # If selected gets the selected template
    if email_selected
      new_email_default = Template.find(id=email_selected)
    end
    if print_selected
      new_print_default = Template.find(id=print_selected)
    end
    
    # If new selected and different to the current one, update
    if new_email_default and new_email_default != current_email_default
      Template.update_all("`email_default` = false")
      new_email_default.email_default = true
      new_email_default.save()
    end
    if new_print_default and new_print_default != current_print_default
      Template.update_all("`print_default` = false")
      new_print_default.print_default = true
      new_print_default.save()
    end

    redirect_to templates_url

  end

  # PATCH/PUT /templates/1
  # PATCH/PUT /templates/1.json
  def update
    respond_to do |format|
      if @template.update(template_params)
        format.html { redirect_to templates_url, notice: 'Template was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /templates/1
  # DELETE /templates/1.json
  def destroy
    @template.destroy
    respond_to do |format|
      format.html { redirect_to templates_url, notice: 'Template was successfully destroyed.' }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_template
      @template = Template.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def template_params
      params.require(:template).permit(:name, :template, :subject)
    end
end
