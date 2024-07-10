class ContactEntreprise < ApplicationRecord
  belongs_to :user
  belongs_to :event
  belongs_to :entreprise

  enum category: {
    products_services: 'Our products and/or Services',
    job_offers: 'Our job offers',
    partnership: 'Partnership'
  }
  
end
