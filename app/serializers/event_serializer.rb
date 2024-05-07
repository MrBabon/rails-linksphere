class EventSerializer
  include JSONAPI::Serializer
  attributes :title, :address, :latitude, :longitude, :city, :country, :region, :link,
  :description, :start_time, :end_time, :registration_code, :industry, :logo_url

  has_many :participants, if: proc { |record, params|
    params && params[:include_participants] == true
  }

  

end
