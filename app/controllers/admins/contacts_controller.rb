class Admins::ContactsController < Admins::BaseController

  def index
    respond_to do |format|
      format.html
      format.json { render json: ContactsDatatable.new(view_context) }
    end
  end

  def show
    @contact = Contact.find(params[:id])
  end

  def destroy
    @contact = Contact.find(params[:id])
    @contact.destroy
    redirect_to admins_contacts_url, :notice => "Successfully destroyed contact."
  end

end
