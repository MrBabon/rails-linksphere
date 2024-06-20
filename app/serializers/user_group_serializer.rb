class UserGroupSerializer
  include JSONAPI::Serializer
  attributes :id, :contact_group_id, :user_contact_group_id

  belongs_to :contact_group, serializer: ContactGroupSerializer, key: :contact_group
  belongs_to :user_contact_group, serializer: UserContactGroupSerializer, key: :user_contact_group
end
