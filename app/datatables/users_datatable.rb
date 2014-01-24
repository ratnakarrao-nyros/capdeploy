class UsersDatatable
  delegate :params, :h, :link_to, :admins_user_path, :content_tag, to: :@view

  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: User.count,
      iTotalDisplayRecords: users.total_entries,
      aaData: data
    }
  end

private

  def data
    users.map do |user|
      [
        link_to(user.email, admins_user_path(user)),
        h(user.sign_in_count),
        h(user.last_sign_in_at),
        h(user.last_sign_in_ip),
        content_tag(:div, link_to('Show', admins_user_path(user), :class => 'btn btn-mini btn-info') + link_to('Delete', admins_user_path(user), :confirm => 'Are you sure?', :method => :delete, :class => 'btn btn-mini btn-danger'))
      ]
    end
  end

  def users
    @users ||= fetch_users
  end

  def fetch_users
    users = User.order("#{sort_column} #{sort_direction}")
    users = users.page(page).per_page(per_page)
    if params[:sSearch].present?
      users = users.where("email iLike :search or last_sign_in_ip iLike :search", search: "%#{params[:sSearch]}%")
    end
    users
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end

  def sort_column
    columns = %w[email sign_in_count last_sign_in_at last_sign_in_ip]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end
end
