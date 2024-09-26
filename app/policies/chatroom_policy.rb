class ChatroomPolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve
      scope.where("user1_id = :user_id OR user2_id = :user_id", user_id: user.id)
    end
  end

  def show?
    # Autoriser uniquement les utilisateurs participants à voir la chatroom
    record.participant?(user)
  end

  def create?
    # Autoriser la création de chatroom pour tous les utilisateurs
    true
  end

  def destroy?
    # Autoriser la suppression de la chatroom uniquement si l'utilisateur est un participant
    record.participant?(user)
  end
end
