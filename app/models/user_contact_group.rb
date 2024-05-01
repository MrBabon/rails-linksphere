class UserContactGroup < ApplicationRecord
  belongs_to :contact_group
  belongs_to :user
end
