class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable
  ALLOWED_PARAMETERS = [:name, :email, :password, :password_confirmation, :remember_me,
                        :avatar, :avatar_cache, :remove_avatar,
                        :bio].freeze

  mount_uploader :avatar, AvatarUploader

  delegate :can?, :cannot?, to: :ability

  def ability
    @ability ||= Ability.new(self)
  end

  def to_param
    name
  end
end
