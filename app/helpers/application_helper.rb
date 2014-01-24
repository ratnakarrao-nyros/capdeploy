module ApplicationHelper

  # Write a secure email address
  def secure_mail_to(email)
    mail_to email, nil, :encode => 'javascript'
  end

  def list_criterias(name="all")
    return nil if name.nil?
    @list_criterias = name == "all" ? ListCriteria.all : ListCriteria.find_by_name(name)
  end

  def app_settings
    @setting = Setting.first
  end

  def title(page_title)
    content_for(:title) { h(page_title.to_s) }
  end

  # helper to generate flash message
  def flash_notify
    message = ""
    flash.each do |name, msg|
      message += javascript_tag "$(function(){ $.pnotify({ text: '#{msg}', sticker: false, history: false, type: '#{name == :notice ? 'success' : 'error'}', styling: 'bootstrap' }); });"
    end
    message.html_safe
  end

  # helper to generate flash message
  def flash_message
    message = ""
    flash.each do |name, msg|
      message += content_tag :div, :class => "alert alert-#{name == :notice ? "success" : "error"}" do
        link_to("x", "#", :class => "close", "data-dismiss" => "alert").concat(msg)
      end
    end
    message.html_safe
  end

  def blank_or_not(object,blank='-')
    if object.blank?
      blank
    else
      if block_given?
        yield
      else
        object
      end
    end
  end

  def is_home_page?
    controller_path == "pages" and controller.params[:id] == "home"
  end

  def is_search_page?
    controller_path == "search_results"
  end

  def is_forum_page?
    controller_path.include? "forums"
  end

end
