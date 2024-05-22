class ContactGroupSerializer
  include JSONAPI::Serializer
  attributes :id, :name, :deletable, :user_count

  attribute :user_count do |contact_group|
    contact_group.user_contact_groups.count
  end
  
end
