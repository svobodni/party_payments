# -*- encoding : utf-8 -*-
class Ability
  include CanCan::Ability

  def initialize(user)
    if [42, 342, 344, 2804, 3860, 7873].member?(user['id'])
      can :manage, :all
    end

    if user['id']==2522
      can :read, :all
    end

    orgs={1 => 100, 2 => 100, 3 => 100, 4 => 100, 5 => 100, 6 => 1, 7 => 2, 8 => 3, 9 => 4, 10 => 5, 11 => 6, 12 => 7, 13 => 8, 14 => 9, 15 => 10, 16 => 11, 17 => 12, 18 => 13, 19 => 14}
    # can :read, :all
    user = user['info']['person']
    user['roles'].each do |role|
      if (role['name'] == "President" || role['name'] == "Vicepresident") && role['organization']['name']=="Krajské předsednictvo" && role['organization']['id'].to_i>5
        # Členové krajského předsednictva
        can [:manage], [Donation,Invoice,BudgetCategory], organization_id: orgs[role['organization']['id']]
      elsif role['organization']['id'].to_i==1
        # Členové republikového předsednictva
        can [:manage], [Donation,Invoice,BudgetCategory], organization_id: 100
      elsif role['organization']['id'].to_i==2
        # Kontrolní komise
        can :read, :all
      end
    end
  end
end
