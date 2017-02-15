class User < ApplicationRecord
  has_one :profile
  before_create :build_profile

  has_many :authored_comments, class_name: 'Comment', inverse_of: :author, validate: false

  mount_uploader :avatar, AvatarUploader

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable
  ALLOWED_PARAMETERS = [:name, :email, :password, :password_confirmation, :remember_me,
                        :avatar, :avatar_cache, :remove_avatar].freeze

  delegate :can?, :cannot?, to: :ability

  def ability
    @ability ||= Ability.new(self)
  end

  def to_param
    name
  end
end
