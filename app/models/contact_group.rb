class ContactGroup < ApplicationRecord
  belongs_to :repertoire

  validates :name, presence: true, length: { maximum: 11 }
end
