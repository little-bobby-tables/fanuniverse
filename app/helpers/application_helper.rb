module ApplicationHelper
  def wide_layout
    content_for(:layout_class) { 'layout--wide' }
  end

  def medium_layout
    content_for(:layout_class) { 'layout--medium' }
  end
end
