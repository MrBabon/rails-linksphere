class RepertoireSerializer
  include JSONAPI::Serializer
  attributes :id, :user_id, :created_at, :updated_at
end
