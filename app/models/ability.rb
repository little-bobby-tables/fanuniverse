class Ability
  include Corral::Ability

  def initialize(user, ip = nil)
    allow_guest_user_actions
    allow_logged_in_user_actions(user) if user
  end

  def allow_guest_user_actions
    can :read, Image
  end

  def allow_logged_in_user_actions(user)
    can :create, Image
  end
end
