class ParticipationSerializer
  include JSONAPI::Serializer
  attributes :id, :user_id, :event_id, :visible_in_participants

  belongs_to :user
end
