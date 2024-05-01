class RepertoirePolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end
  attr_reader :user, :repertoire

  def initialize(user, repertoire)
    @user = user
    @repertoire = repertoire
  end

  def repertoire?
    user.id == repertoire.user_id
  end
  
end
