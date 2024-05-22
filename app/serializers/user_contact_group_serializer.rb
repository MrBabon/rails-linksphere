class UserContactGroupSerializer
  include JSONAPI::Serializer
  attributes :id, :personal_note, :user_id, :contact_group_id

  belongs_to :user, serializer: UserSerializer

end
