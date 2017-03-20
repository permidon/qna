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

    can :create, [Question, Answer, Comment, Vote]

    can :update, [Question, Answer], user: user

    can :destroy, [Question, Answer], user: user

    can :destroy, [Attachment] do |attachment|
      attachment.attachable.user_id == user.id
    end

    can :destroy, [Vote] do |vote|
      vote.attachable.user_id == user.id
    end

    can :mark_best, Answer do |answer|
      answer.question.user_id == user.id
    end
  end
end
