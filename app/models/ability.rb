class Ability
  include CanCan::Ability

  def initialize(user)
    unless user # guest user (not logged in)
      user = User.new
      user.add_role 'unsigned'
    end

    alias_action :create, :read, :update, :destroy, :to => :crud

    if user.has_role? :admin
      can :manage, :all
      can :invite, User
    elsif user.has_role? :member
      can :manage, EntityInstance
      can :manage, Relationship
      can :manage, SuggestRelationship
      can [:edit, :update], User do |user|
        user == user
      end
      cannot :index, User
    elsif user.has_role? :unsigned
      can :preview, [EntityInstance, Relationship]
      can :index, RelationshipBit
      can :create, SuggestRelationship
    end
  end
end
