class ContactGroup < ApplicationRecord
  belongs_to :repertoire
  has_many :user_groups, dependent: :destroy
  has_many :user_contact_groups, through: :user_groups
  has_many :users, through: :user_contact_groups

  validates :name, presence: true, length: { maximum: 11 }

  def user_count
    users.count
  end

end
