class ParticipationSerializer
  include JSONAPI::Serializer
  attributes :id, :user_id, :event_id, :created_at, :updated_at
end
