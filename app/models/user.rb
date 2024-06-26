class User < ApplicationRecord
  after_create :create_default_repertoire
  after_create :generate_qr_code

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

  before_destroy :destroy_related_records
  # REPERTOIRE
  has_one :repertoire, dependent: :destroy

  # CHATROOM & MESSAGE
  has_many :messages, dependent: :destroy
  # USERS_CONTACT_GROUPS
  has_many :user_contact_groups, dependent: :destroy
  has_many :contact_groups, through: :repertoire
  has_many :user_groups, through: :contact_groups

  # PARTICIPATION
  has_many :participations, dependent: :destroy
  has_many :participating_events, through: :participations, source: :event
  has_many :events, through: :participations

  # BLOCK
  has_many :blocks_given, foreign_key: :blocker_id, class_name: 'Block', dependent: :destroy
  has_many :blocked_users, through: :blocks_given, source: :blocked
  has_many :blocks_received, foreign_key: :blocked_id, class_name: 'Block', dependent: :destroy
  has_many :blockers, through: :blocks_received, source: :blocker

  # ENTREPRENEUR
  has_many :entrepreneurs, dependent: :destroy
  has_many :entreprises_as_owner, through: :entrepreneurs, source: :entreprise
  # EMPLOYEE
  has_many :employee_relationships, class_name: 'Employee', dependent: :destroy
  has_many :entreprises_as_employee, through: :employee_relationships, source: :entreprise

  #  PG SEARCH
  include PgSearch::Model
  pg_search_scope :search_by_name,
                  against: [:first_name, :last_name],
                  using: { tsearch: { prefix: true } }

  ##########################
  # FUNCTION USER
  ##########################

  def industry_form_value
    industry.presence || "Industry not specified"
  end


  def entrepreneurs?
    entreprises_as_owner.exists?
  end

  def employee_relationships?
    entreprises_as_employee.exists?
  end

  private

  def create_default_repertoire
    create_repertoire!
  end

  def generate_qr_code
    require 'rqrcode'
    require 'base64'


    base_url = ENV['BASE_URL']
    url = "#{base_url}/redirect?user_id=#{self.id}"

    # Génération du QR code
    qrcode = RQRCode::QRCode.new(url)

    # Convertir le QR code en image PNG
    png = qrcode.as_png(
      bit_depth: 1,
      border_modules: 4,
      color_mode: ChunkyPNG::COLOR_GRAYSCALE,
      color: 'black',
      fill: 'white',
      module_px_size: 10,
      size: 120
    )

    # Convertir l'image PNG en base64
    self.qr_code = Base64.encode64(png.to_s)
    save!
  end

  def destroy_related_records
    self.repertoire.contact_groups.each do |contact_group|
      contact_group.user_groups.each do |user_group|
        user_group.destroy
      end
      contact_group.destroy
    end
    self.repertoire.destroy
  end

end
