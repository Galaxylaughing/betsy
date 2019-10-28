module ApplicationHelper
  def render_date(date)
    return date.strftime("%b %e, %Y")
  end
end
