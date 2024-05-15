class Event < ApplicationRecord
  belongs_to :entreprise
  has_many :participations, dependent: :destroy
  has_many :participants, through: :participations, source: :user

  has_many :exhibitors, dependent: :destroy
  # has_many :contact_entreprises, dependent: :destroy
  validates :registration_code, presence: true

  has_one_attached :logo
  def logo_url
    if logo.attached?
      "https://res.cloudinary.com/#{ENV['CLOUDINARY_CLOUD_NAME']}/image/upload/#{Rails.env}/#{logo.key}"
    end
  end
  # PG SEARCH
  include PgSearch::Model
  pg_search_scope :search_by_industry,
      against: :industry,
      using: {
      tsearch: { prefix: true } 
      }
  pg_search_scope :search_by_city,
      against: :city,
      using: {
      tsearch: { prefix: true } 
      }
  pg_search_scope :search_by_country,
      against: :country,
      using: {
      tsearch: { prefix: true } 
      }
  pg_search_scope :search_by_region,
      against: :region,
      using: {
      tsearch: { prefix: true } 
      }
    pg_search_scope :search_by_title,
      against: :title,
      using: {
      tsearch: { prefix: true } 
      }
  
  geocoded_by :address do |obj, results|
    if geo = results.first
    obj.latitude = geo.latitude
    obj.longitude = geo.longitude
    obj.city = geo.city
    obj.country = geo.country
    obj.region = geo.state || geo.province || geo.region
    end
  end
  after_validation :geocode, if: :will_save_change_to_address?

  def valid_registration_code?(code)
    event_code = registration_code
    errors.add(:registration_code, 'Code de participation incorrect') unless code == event_code
    errors.empty? 
  end

  
  # Pour voir si current_user est bien enregistrer dans l'event
  def user_registered?(user)
    return false if user.nil?
    registered = participations.exists?(user: user)
    Rails.logger.debug "User #{user.id} registered for Event #{id}: #{registered}"
    registered
  end

  def user_visible_in_participants?(user)
    return false if user.nil?
    participation = participations.find_by(user: user)
    visible = participation.present? && participation.visible_in_participants
    Rails.logger.debug "User #{user.id} visible in participants for Event #{id}: #{visible}"
    visible
  end

end

