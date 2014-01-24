class AdminsDatatable
  delegate :params, :h, :link_to, :admins_admin_path, :content_tag, to: :@view

  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: Admin.count,
      iTotalDisplayRecords: admins.total_entries,
      aaData: data
    }
  end

private

  def data
    admins.map do |admin|
      [
        link_to(admin.email, admins_admin_path(admin)),
        h(admin.sign_in_count),
        h(admin.failed_attempts),
        h(admin.current_sign_in_at.to_s(:long)),
        h(admin.last_sign_in_at.to_s(:long)),
        content_tag(:div, link_to('Show', admins_admin_path(admin), :class => 'btn btn-mini btn-info') + link_to('Delete', admins_admin_path(admin), :confirm => 'Are you sure?', :method => :delete, :class => 'btn btn-mini btn-danger'))
      ]
    end
  end

  def admins
    @admins ||= fetch_admins
  end

  def fetch_admins
    admins = Admin.order("#{sort_column} #{sort_direction}")
    admins = admins.page(page).per_page(per_page)
    if params[:sSearch].present?
      admins = admins.where("email iLike :search", search: "%#{params[:sSearch]}%")
    end
    admins
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end

  def sort_column
    columns = %w[email sign_in_count failed_attempts current_sign_in_at last_sign_in_at]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end

end
