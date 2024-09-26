class Chatroom < ApplicationRecord
    belongs_to :user1, class_name: 'User', foreign_key: 'user1_id'
    belongs_to :user2, class_name: 'User', foreign_key: 'user2_id'
    has_many :messages, dependent: :destroy

    validates :user1_id, uniqueness: { scope: :user2_id, message: "Chatroom already exists between these users" }
    validate :users_must_be_different

    def users_must_be_different
        if user1_id == user2_id
            errors.add(:user1_id, "Users must be different")
        end
    end

    def other_user(current_user)
        user1 == current_user ? user2 : user1
    end

    def participant?(user)
        user1_id == user.id || user2_id == user.id
    end
end
