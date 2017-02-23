class Ability
  include Corral::Ability

  def initialize(user)
    allow_guest_user_actions
    allow_logged_in_user_actions(user) if user
  end

  def allow_guest_user_actions
    can :view, Image
    can :view, Profile
  end

  def allow_logged_in_user_actions(user)
    can :create, Image
    can :edit, Image
    can :comment_on, Image
    can :comment_on, Profile
    can :star, Image
    can :star, Comment
  end
end
