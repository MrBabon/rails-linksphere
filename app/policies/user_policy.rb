class UserPolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def profil?
    user == record  # Permet à l'utilisateur de voir son propre profil uniquement
  end

  def my_events?
    user == record
  end

  def show?
    true
  end

  def update_preferences?
    user == record
  end
end
