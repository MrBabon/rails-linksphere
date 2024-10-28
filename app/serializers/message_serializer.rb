class MessageSerializer
  include JSONAPI::Serializer
  attributes :id, :content, :user_id, :created_at, :updated_at

  belongs_to :user, serializer: UserSerializer
end
