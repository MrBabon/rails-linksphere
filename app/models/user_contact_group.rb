class UserContactGroup < ApplicationRecord
  belongs_to :user
  belongs_to :current_user, class_name: 'User', foreign_key: 'current_user_id'
  has_many :user_groups, dependent: :destroy
  has_many :contact_groups, through: :user_groups

  validates :user_id, presence: true
  validates :current_user_id, presence: true
  validates :user_id, uniqueness: { scope: :current_user_id, message: "user is already in this contact group for the current user" }
end
