class Ability
  include CanCan::Ability

  def initialize(user)
    unless user.nil?
      if user.admin?
        can :manage, :all
        return
      end
    end

  end
end
