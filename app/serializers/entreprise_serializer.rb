class EntrepriseSerializer
  include JSONAPI::Serializer
  attributes :id, :name, :email, :website, :linkedin, :instagram, :facebook, :twitter, 
  :headline, :industry, :description, :siret_number, :tva_number, :address, 
  :phone_number, :establishment_date, :legal_status, :latitude, :longitude, 
  :country, :city, :region
  
end
