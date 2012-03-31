module ApplicationHelper
	
  def time_ago(time)
    t 'meta.time_ago', :time => time_ago_in_words(time)
  end

  def time_ago_by(time)
    t 'meta.time_ago_by', :time => time_ago_in_words(time)
  end

  def link_to_current(*params)
    link_to_unless_current(*params) do
      link_to *params, :class => 'current'
    end
  end

  def show_pagination(collection, *params)
    pagination = paginate(collection, *params) rescue nil

    "<div class='clear'></div><hr />#{pagination}".html_safe if pagination
  end

end
