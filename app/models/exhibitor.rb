class Exhibitor < ApplicationRecord
  belongs_to :event
  belongs_to :entreprise
end
