class ForumCategoriesDatatable
  delegate :params, :h, :link_to, :admins_forum_category_path, :content_tag, to: :@view

  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: ForumCategory.count,
      iTotalDisplayRecords: forum_categories.total_entries,
      aaData: data
    }
  end

private

  def data
    forum_categories.map do |forum_category|
      [
        link_to(forum_category.title, admins_forum_category_path(forum_category)),
        h(forum_category.state),
        h(forum_category.position),
        content_tag(:div, link_to('Show', admins_forum_category_path(forum_category), :class => 'btn btn-mini btn-info') + link_to('Delete', admins_forum_category_path(forum_category), :confirm => 'Are you sure?', :method => :delete, :class => 'btn btn-mini btn-danger'))
      ]
    end
  end

  def forum_categories
    @forum_categories ||= fetch_forum_categories
  end

  def fetch_forum_categories
    forum_categories = ForumCategory.order("#{sort_column} #{sort_direction}")
    forum_categories = forum_categories.page(page).per_page(per_page)
    if params[:sSearch].present?
      forum_categories = forum_categories.where("title iLike :search", search: "%#{params[:sSearch]}%")
    end
    forum_categories
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end

  def sort_column
    columns = %w[title]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end
end
