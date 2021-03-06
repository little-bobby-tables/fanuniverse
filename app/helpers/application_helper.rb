# frozen_string_literal: true
module ApplicationHelper
  $assets ||= Assets.new

  def title(title)
    content_for :page_title, title
  end

  def no_index
    content_for :no_index, true
  end

  def wide_layout
    content_for :layout_class, 'layout--wide'
  end

  def medium_layout
    content_for :layout_class, 'layout--medium'
  end

  def custom_layout
    content_for :layout_class, 'layout--custom'
  end

  def asset_path(name)
    $assets.path(name)
  end

  def stars_for(resources)
    if user_signed_in? && resources.any?
      type = resources.first.model_name.name
      stars = Star.where(user: current_user,
                         starrable_type: type,
                         starrable_id: resources.map(&:id)).pluck(:starrable_id)
      if stars.any?
        # Don't use #tag, it closes the element with />, which messes up Slim.
        content_tag 'div', '', 'data-starrable-type': type, 'data-starrable-ids': stars.to_json
      end
    end
  end

  def comments_for(resource, id: nil)
    commentable = { commentable_id: resource.id, commentable_type: resource.model_name.name }
    attributes = { 'data-commentable-url': comments_path(commentable) }
    attributes[:id] = id if id
    content_tag 'div', '', attributes
  end
end
