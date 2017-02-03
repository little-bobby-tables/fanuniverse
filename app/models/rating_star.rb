class RatingStar < ApplicationRecord
  def self.toggle(user_id:, resource_id:)
    if exists? user_id: user_id, resource_id: resource_id
      remove(user_id, resource_id)
    else
      add(user_id, resource_id)
    end
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
