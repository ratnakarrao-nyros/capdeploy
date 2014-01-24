class ContactsController < ApplicationController
  def new
    @contact = Contact.new
  end

  def create
    @contact = Contact.new(params[:contact])
    if @contact.save
      redirect_to root_path, :notice => "Thank you for your message"
    else
      render :new
    end
  end
end
