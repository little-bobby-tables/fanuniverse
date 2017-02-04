module ApplicationHelper
  $assets ||= Assets.new

  def wide_layout
    content_for(:layout_class) { 'layout--wide' }
  end

  def medium_layout
    content_for(:layout_class) { 'layout--medium' }
  end

  def asset_path(name)
    $assets.path(name)
  end
end
