class ChatroomSerializer
  include JSONAPI::Serializer
  attributes :id, :user1_id, :user2_id, :created_at, :updated_at

  has_many :messages, serializer: MessageSerializer
  belongs_to :user1, serializer: UserSerializer
  belongs_to :user2, serializer: UserSerializer

  attribute :other_user do |chatroom, params|
    current_user = params[:current_user]
    other_user = chatroom.other_user(current_user)
    UserSerializer.new(other_user).serializable_hash[:data][:attributes]
  end

end
