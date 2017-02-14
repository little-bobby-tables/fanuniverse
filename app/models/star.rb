class Star < ApplicationRecord
  # This model doesn't use Rails associations because it's updated
  # through a single controller that needs a single method: #toggle.

  # Starrable models are defined below.
  # They _must_ have a "star_count" column with default set to 0.
  STARRABLE = %w(Image).freeze

  validate :validate_starrable_resource

  def validate_starrable_resource
    errors.add(:base, 'invalid type') and return if STARRABLE.exclude? starrable_type
    errors.add(:base, 'non-existent resource') unless starrable_type.constantize.exists? id: starrable_id
  end

  def self.toggle(type:, id:, user_id:)
    if exists? starrable_type: type, starrable_id: id, user_id: user_id
      remove type, id, user_id
    else
      add type, id, user_id
    end
  end

  def self.starred_ids(user:, resources_of_single_type:)
    type = resources_of_single_type.first.model_name.name
    where(starrable_type: type,
          starrable_id: resources_of_single_type.map(&:id),
          user_id: user.id).pluck(:starrable_id)
  end

  def self.starred_by_ids(resource)
    where(starrable_type: resource.model_name.name, starrable_id: resource.id).pluck(:user_id)
  end

  private

  def self.add(type, id, user_id)
    if new(starrable_type: type, starrable_id: id, user_id: user_id).save
      type.constantize.where(id: id).update_all 'star_count = star_count + 1'
      :added
    end
  end

  def self.remove(type, id, user_id)
    if where(starrable_type: type, starrable_id: id, user_id: user_id).delete_all != 0
      type.constantize.where(id: id).update_all 'star_count = star_count - 1'
      :removed
    end
  end
end
