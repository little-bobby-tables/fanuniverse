# frozen_string_literal: true

class Tags
  DELIM = ', '

  def initialize(resource)
    @resource = resource
  end

  def tags=(tag_string)
    update(tag_string, compare_against: '')
  end

  def to_s
    @resource.tag_names.join(DELIM)
  end

  def added
    return [] unless @resource.previous_changes[:tag_names]
    Tag.where(name: @resource.previous_changes[:tag_names].last - @resource.previous_changes[:tag_names].first)
  end

  def removed
    return [] unless @resource.previous_changes[:tag_names]
    Tag.where(name: @resource.previous_changes[:tag_names].first - @resource.previous_changes[:tag_names].last)
  end

  def update(tag_string, compare_against:)
    before = Tag.string_to_names(compare_against)
    after = Tag.string_to_names(tag_string)
    @resource.tag_names += (after - before)
    @resource.tag_names -= (before - after)
  end

  def apply_tag_change
    @resource.tag_names.uniq!

    added = @resource.tag_names - @resource.tag_names_was
    removed = @resource.tag_names_was - @resource.tag_names

    new_records_added = added - relation(added).pluck(:name)
    new_records_added.each do |name|
      Tag.create name: name, image_count: 1
    end

    relation(added - new_records_added).update_all 'image_count = image_count + 1'
    relation(removed).update_all 'image_count = image_count - 1'
  end

  def method_missing(name, *args, &block)
    tags_relation.send(name, *args, &block)
  end

  private

  def relation(tag_names = @resource.tag_names)
    Tag.where(name: tag_names)
  end
end