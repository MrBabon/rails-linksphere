class EventPolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve
      scope.all
    end
  end

  def show?
    true
  end

  def exposant?
    true
  end

  def visitor?
    participant_visible?
  end

  private

  def participant_visible?
    participation = record.participations.find_by(user: user)
    participation&.visible_in_participants || false
  end
  
end
