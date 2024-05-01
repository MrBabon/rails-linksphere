class Participation < ApplicationRecord
  belongs_to :event
  belongs_to :user
  validate :validate_registration_code
  
  def self.participation_for(user, event)
    Participation.find_by(user: user, event: event)
  end
  
  private

  def validate_registration_code
    event_code = event.registration_code

    errors.add(:registration_code, 'Code de participation incorrect') unless event_code.present? && event_code == self.event.registration_code
  end
end
