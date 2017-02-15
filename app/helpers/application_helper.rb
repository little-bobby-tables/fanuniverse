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

  def stars_for(resources)
    if user_signed_in?
      stars = Star.starred_hash(user: current_user, resources_of_single_type: resources)
      # Don't use #tag, it closes the element with />, which messes up Slim.
      content_tag 'div', '', 'data-starrable-dataset': stars.to_json
    end
  end

  def comments_for(resource)
    commentable = { commentable_id: resource.id, commentable_type: resource.model_name.name }
    content_tag 'div', '', 'data-commentable-url': comments_path(commentable)
  end
end
