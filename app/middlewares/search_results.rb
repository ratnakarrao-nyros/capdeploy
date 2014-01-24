class SearchResults

  def initialize(app)
    @app = app
  end

  def call(env)
    if env["PATH_INFO"].include? "/search_results"
      @request = Rack::Request.new(env)
      @params = @request.params
      get_search_results(env)
    else
      @app.call(env)
    end
  end

protected

  def get_search_results(env)
    if env["PATH_INFO"] == "/search_results/users"
      [200, {"Content-Type" => "application/json"}, [users.to_json]]
    elsif env["PATH_INFO"] == "/search_results/items"
      [200, {"Content-Type" => "application/json"}, [items.to_json]]
    elsif env["PATH_INFO"] == "/search_results/lists"
      [200, {"Content-Type" => "application/json"}, [lists.to_json]]
    elsif env["PATH_INFO"] == "/search_results/list_categories"
      [200, {"Content-Type" => "application/json"}, [list_categories.to_json]]
    else
      @app.call(env)
    end
  end

  def users
    if @params['q'].present?
      search = User.where('email ilike ?', "%#{@params['q']}%")
      search.map { |u| { "id" => u.id, "email" => u.email } }
    else
      User.all
    end
  end

  def items
    if @params['term'].present?
      search = Item.where("name ilike :term or description ilike :term", term: "%#{@params['term']}%")
      search.map { |i| { "id" => i.id, "name" => i.name, "description" => ( i.description.nil? ? nil : i.description.html_safe ), "image" => ( i.image.nil? ? nil : i.image.thumb.url ) } }
    else
      Item.all
    end
  end

  def lists
    if @params['term'].present?
      search = List.where("name ilike :term or description ilike :term", term: "%#{@params['term']}%")
      search.map { |i| { "id" => i.id, "name" => i.name } }
    else
      List.all
    end
  end

  def list_categories
    Category.all
  end

end
