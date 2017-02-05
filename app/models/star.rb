class Star < ApplicationRecord
  def self.toggle(user_id:, resource_id:)
    if exists? user_id: user_id, resource_id: resource_id
      remove(user_id, resource_id)
      :removed
    else
      add(user_id, resource_id)
      :added
    end
  end

  def self.resource_ids_with_stars(user:, resources:)
    where(user_id: user.id, resource_id: resources.map(&:id)).pluck(:resource_id)
  end

  def self.user_ids_for_resource(resource)
    where(resource_id: resource.id).pluck(:user_id)
  end

  private

  def self.add(user_id, resource_id)
    create(user_id: user_id, resource_id: resource_id)

    Image.where(id: resource_id).update_all 'stars = stars + 1'
  end

  def self.remove(user_id, resource_id)
    where(user_id: user_id, resource_id: resource_id).delete_all

    Image.where(id: resource_id).update_all 'stars = stars - 1'
  end
end
