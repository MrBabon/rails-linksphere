class EntrepriseSerializer
  include JSONAPI::Serializer
  attributes :id, :name, :email, :website, :linkedin, :instagram, :facebook, :twitter, 
  :headline, :industry, :description, :siret, :tva, :address, 
  :phone, :establishment, :legal_status, :latitude, :longitude, 
  :country, :city, :region, :logo_url, :banner_url
  
  has_many :employees, serializer: EmployeeSerializer
  has_many :entrepreneurs, serializer: EntrepreneurSerializer
  
end
