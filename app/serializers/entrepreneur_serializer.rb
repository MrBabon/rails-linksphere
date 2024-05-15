class EntrepreneurSerializer
  include JSONAPI::Serializer
  attributes :user_id, :entreprise_id
end
