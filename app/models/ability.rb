class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user= user

    if user
      user.admin? ? admin_abilities : user_abilities
    else
      quest_abilities
    end
  end

  protected

  def quest_abilities
    can :read, :all
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    quest_abilities
    can :create, [Question]
    can :update, [Question], user: user
    can :destroy, [Question], user: user
  end
end
