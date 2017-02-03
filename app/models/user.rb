class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable
  ALLOWED_PARAMETERS = [:name, :email, :password, :password_confirmation, :remember_me].freeze

  def to_param
    name
  end
end
