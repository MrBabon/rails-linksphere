class EventSerializer
  include JSONAPI::Serializer
  attributes :title, :address, :latitude, :longitude, :city, :country, :region, :link,
  :description, :start_time, :end_time, :registration_code, :industry, :logo_url


  attribute :is_registered do |event, params|
    event.user_registered?(params[:current_user])
  end

  attribute :is_visible_in_participants do |event, params|
    event.user_visible_in_participants?(params[:current_user])
  end

  attribute :participation_id do |event, params|
    participation = event.participations.find_by(user: params[:current_user])
    participation&.id
  end

  has_many :exhibitors, serializer: ExhibitorSerializer
  has_many :participations, serializer: ParticipationSerializer

  has_many :participants, serializer: ParticipationSerializer, if: proc { |record, params|
  params && params[:include_participants] == true
  }

end
