class ContactGroupSerializer
  include JSONAPI::Serializer
  attributes :id, :name, :deletable
end
