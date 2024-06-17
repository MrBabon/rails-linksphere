class UserGroup < ApplicationRecord
  belongs_to :user_contact_group
  belongs_to :contact_group
end
