class UserContactGroup < ApplicationRecord
  belongs_to :user
  has_many :user_groups, dependent: :destroy
  has_many :contact_groups, through: :user_groups

  validates :user_id, presence: true
  validates :personal_note, presence: false
end
