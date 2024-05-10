class Exhibitor < ApplicationRecord
  
  belongs_to :event
  belongs_to :entreprise
  # has_many :representatives, dependent: :destroy
end
