class ContactsDatatable
  delegate :params, :h, :link_to, :admins_contact_path, :content_tag, :truncate, to: :@view

  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: Contact.count,
      iTotalDisplayRecords: contacts.total_entries,
      aaData: data
    }
  end

private

  def data
    contacts.map do |contact|
      [
        link_to(contact.email, admins_contact_path(contact)),
        h(truncate(contact.content, :length => 50)),
        content_tag(:div, link_to('Show', admins_contact_path(contact), :class => 'btn btn-mini btn-info') + link_to('Delete', admins_contact_path(contact), :confirm => 'Are you sure?', :method => :delete, :class => 'btn btn-mini btn-danger'))
      ]
    end
  end

  def contacts
    @contacts ||= fetch_contacts
  end

  def fetch_contacts
    contacts = Contact.order("#{sort_column} #{sort_direction}")
    contacts = contacts.page(page).per_page(per_page)
    if params[:sSearch].present?
      contacts = contacts.where("email iLike :search or content iLike :search", search: "%#{params[:sSearch]}%")
    end
    contacts
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end

  def sort_column
    columns = %w[email content]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end
end
