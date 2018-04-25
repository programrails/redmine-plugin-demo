# class ContactsController
class ContactsController < ApplicationController
  self.main_menu = false
  before_action :set_contact, only: %i[show edit update destroy]
  before_filter :find_project, only: :index

  helper :custom_fields
  include CustomFieldsHelper

  # GET /contacts
  # GET /contacts.json
  def index
    @contacts = Contact

    if params[:project_id]
      # https://stackoverflow.com/q/680141/6594668
      @contacts = Contact.where(contactable_type: 'Project')
                         .joins('INNER JOIN projects ON contacts.contactable_id = projects.id')
                         .where(projects: { identifier: params[:project_id] }).all
    end

    @contacts = @contacts.where(id: params[:id]) if params[:id]

    @contacts = @contacts.all
  end

  # GET /contacts/1
  # GET /contacts/1.json
  def show; end

  # GET /contacts/new
  def new
    @contact = Contact.new
  end

  # GET /contacts/1/edit
  def edit; end

  # POST /contacts
  # POST /contacts.json
  def create
    @contact = Contact.new(contact_params)

    respond_to do |format|
      if @contact.save
        format.html { redirect_to @contact, notice: 'Contact was successfully created.' }
        format.json { render :show, status: :created, location: @contact }
      else
        format.html { render :new }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /contacts/1
  # PATCH/PUT /contacts/1.json
  def update
    respond_to do |format|
      if @contact.update(contact_params)
        format.html { redirect_to @contact, notice: 'Contact was successfully updated.' }
        format.json { render :show, status: :ok, location: @contact }
      else
        format.html { render :edit }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /contacts/1
  # DELETE /contacts/1.json
  def destroy
    @contact.destroy
    respond_to do |format|
      format.html { redirect_to contacts_url, notice: 'Contact was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_contact
    @contact = Contact.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def contact_params
    # par = params.require(:contact).permit(:ctype, :company_website, :company_tax_id,
    #                                       :company_info, :full_name, :person_phone)

    # For a test I chose to simply disable the params whitelisting.
    # Otherwise the 'custom_field_values' hash wouldn't be whitelisted as
    # fast and easy as a plain param.
    # In Redmine they use some Redmine::SafeAttributes functions for that.
    par = params.require(:contact).permit!

    if params[:parent_type_id]
      par[:contactable_type] = params[:parent_type_id].split('#').first

      par[:contactable_id] = params[:parent_type_id].split('#').second
    end

    par
  end

  def find_project
    @project = Project.find params[:project_id] if params[:project_id]
    # Local permissions
    authorize if @project
    # Global permissions
    deny_access unless User.current.allowed_to_globally?(:global_view_contacts)
  end
end
