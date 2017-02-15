class Star < ApplicationRecord
  STARRABLE = %w(Image).freeze

  belongs_to :starrable, polymorphic: true, counter_cache: 'star_count'
  belongs_to :user

  def self.toggle(user_id)
    if exists? user_id: user_id
      find_by(user_id: user_id).destroy
      :removed
    else
      create(user_id: user_id)
      :added
    end
  end
end
