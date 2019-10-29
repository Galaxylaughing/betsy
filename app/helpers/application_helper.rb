module ApplicationHelper
  def render_date(date)
    return date.strftime("%b %e, %Y")
  end
  
  def render_price(price)
    return "%.2f" % price.floor(2)
  end
end
