class Ability
  include CanCan::Ability

  def initialize(user)
    unless user.nil?
      if user.admin?
        can :manage, :all
        return
      end
      alias_action :new, :to => :create
      alias_action :edit, :to => :update

      can :read, Instance
      can :backup, Instance
      can :clear, Instance
      can :reset_pass, Instance
      can :recovery, Instance

      can :read, BackupRecord
      can :fetch, BackupRecord
    end

  end
end
