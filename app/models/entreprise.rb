class Entreprise < ApplicationRecord
    # ENTREPRENEUR
    has_many :entrepreneurs, dependent: :destroy
    has_many :owners, through: :entrepreneurs, source: :user
    # EMPLOYEE
    has_many :employee_relationships, class_name: 'Employee', dependent: :destroy
    has_many :employees, through: :employee_relationships, source: :user
    # EVENT
    has_many :events, dependent: :destroy
    # EXHIBITOR
    has_many :exhibitors, dependent: :destroy
    # ENTREPRISE CONTACT GROUP
    has_many :entreprise_contact_groups, dependent: :destroy
    has_many :repertoires, through: :entreprise_contact_groups

    # PG SEARCH
    include PgSearch::Model
    pg_search_scope :search_by_name,
                    against: [:name],
                    using: { tsearch: { prefix: true } }

    has_one_attached :logo
    def logo_url
        if logo.attached?
          "https://res.cloudinary.com/#{ENV['CLOUDINARY_CLOUD_NAME']}/image/upload/#{Rails.env}/#{logo.key}"
        end
    end
    has_one_attached :banner
    def banner_url
        if banner.attached?
          "https://res.cloudinary.com/#{ENV['CLOUDINARY_CLOUD_NAME']}/image/upload/#{Rails.env}/#{banner.key}"
        end
    end
    validates :name, presence: true
    validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
end
