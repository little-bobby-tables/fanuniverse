class Ability
  include Corral::Ability

  def initialize(user)
    allow_guest_user_actions
    allow_logged_in_user_actions(user) if user
  end

  def allow_guest_user_actions
    can :view, Image
  end

  def allow_logged_in_user_actions(user)
    can :create, Image
    can :comment_on, Image
    can :star, Image
    can :star, Comment
  end
end
