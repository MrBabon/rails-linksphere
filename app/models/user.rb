class User < ApplicationRecord
  after_create :create_default_repertoire

  include Devise::JWT::RevocationStrategies::JTIMatcher
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :validatable, :jwt_authenticatable, jwt_revocation_strategy: self

  ##################################
  # VALIDATES USER 
  ##################################      
  validates :first_name, presence: true, length: { maximum: 17 }, format: { without: /\s/ }
  validates :last_name, presence: true, length: { maximum: 20 }, format: { without: /\s/ }
  validates :phone, phone: { message: I18n.t('errors.messages.invalid_phone_number') }
  validates :biography, length: { maximum: 1000 }

  enum industry: {
    agriculture: "Agriculture",
    art_design: "Art & Design",
    education: "Education",
    energy: "Energy",
    engineering: "Engineering",
    environment: "Environment",
    finance: "Finance",
    health: "Healthcare",
    human_resources: "Human Resources",
    manufacturing: "Manufacturing",
    media: "Media",
    professional_services: "Professional Services",
    public_administration: "Public Administration",
    real_estate: "Real Estate",
    retail: "Retail",
    science: "Science",
    technology: "Technology",
    telecommunications: "Telecommunications",
    tourism: "Tourism",
    transportation: "Transportation",
  }
  validates :industry, inclusion: { in: industries.keys, message: "Industry invalid" }, allow_blank: true

  ##################################
  # ATTACHEMENT USER 
  ##################################
  # AVATAR
  has_one_attached :avatar
  def avatar_url
    if avatar.attached?
      "https://res.cloudinary.com/#{ENV['CLOUDINARY_CLOUD_NAME']}/image/upload/#{Rails.env}/#{avatar.key}"
    end
  end
  
  # REPERTOIRE
  has_one :repertoire, dependent: :destroy
  
  private 

  def create_default_repertoire
    create_repertoire!
  end
end
