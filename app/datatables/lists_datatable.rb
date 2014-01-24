class ListsDatatable
  delegate :params, :h, :link_to, :admins_list_path, :users_list_path, :content_tag, :current_user, to: :@view

  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: List.count,
      iTotalDisplayRecords: lists.total_entries,
      aaData: data
    }
  end

private

  def data
    lists.map do |list|
      if params[:controller] == "admins/lists"
        [
          link_to(list.name, admins_list_path(list)),
          h(list.description),
          h(list.category.name),
          content_tag(:div, link_to('Show', admins_list_path(list), :class => 'btn btn-mini btn-info') + link_to('Delete', admins_list_path(list), :confirm => 'Are you sure?', :method => :delete, :class => 'btn btn-mini btn-danger'))
        ]
      else
        [
          link_to(list.name, users_list_path(list)),
          h(list.category.name)
        ]
      end
    end
  end

  def lists
    @lists ||= fetch_lists
  end

  # All lists needs to be return ActiveRecord::Relation object
  # All criteria name should be using symbol
  def fetch_lists
    if params[:criteria].present?
      if list_criteria = ListCriteria.find_by_name(params[:criteria])
        lists = list_criteria.all
      else
        lists = current_user.send(params[:criteria])
      end
      lists = lists.order("#{sort_column} #{sort_direction}")
    else
      lists = List.order("#{sort_column} #{sort_direction}")
    end

    lists = lists.where(:category_id => params[:category]) if params[:category].present?
    lists = lists.where("lists.name iLike :search or lists.description iLike :search", search: "%#{params[:sSearch]}%") if params[:sSearch].present?

    lists = lists.page(page).per_page(per_page)
    lists
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    if params[:controller] == "admins/lists"
      params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
    else
      20
    end
  end

  def sort_column
    columns = %w[lists.name lists.description]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end

end
