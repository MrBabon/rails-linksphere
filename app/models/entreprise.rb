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



    has_one_attached :logo
    has_one_attached :banner

    validates :name, presence: true
    validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
end
