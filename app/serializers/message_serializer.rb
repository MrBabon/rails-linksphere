class MessageSerializer
  include JSONAPI::Serializer
  attributes :id, :content, :created_at, :user_id

  belongs_to :user, serializer: UserSerializer
end
