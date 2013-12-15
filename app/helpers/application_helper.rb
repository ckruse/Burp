module ApplicationHelper
  def id_from_params
    id = ""

    if params[:year] and params[:mon] and params[:slug]
      id = params[:year] + "/" + params[:mon] + "/" + params[:slug]
    end

    id
  end


  def post_path(p)
    root_path + p.slug
  end

  def comments_path(p)
    post_path(p) + "#comments"
  end

  def post_url(p)
    p.blog.url + p.slug
  end

  def comments_url(p)
    post_url(p) + "#comments"
  end

  def comment_url(p, c)
    post_url(p) + "#comment-" + c.id.to_s
  end

  def archive_month_path(mon, y = nil)
    if y.nil?
      mon.strftime('/archive/%Y/%b').downcase
    else
      m = [nil, 'jan', 'feb', 'mar', 'apr', 'may', 'jun', 'jul', 'aug', 'sep', 'oct', 'nov', 'dec'][mon.to_i]
      "/archive/#{y}/#{m}"
    end
  end

  def archive_month_url(mon)
    root_url + mon.strftime('/archive/%Y/%b').downcase
  end


end
